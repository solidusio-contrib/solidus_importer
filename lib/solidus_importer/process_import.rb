# frozen_string_literal: true

require 'csv'

module SolidusImporter
  ##
  # This class parse the source file and create the rows (scan). Then it asks to
  # Process Row to process each one.
  class ProcessImport
    attr_reader :importer

    def initialize(import, importer_options: nil)
      @import = import
      options = importer_options || ::SolidusImporter::Config.solidus_importer[@import.import_type.to_sym]
      @importer = options[:importer].new(options)
      @import.importer = @importer
      validate!
    end

    def process(force_scan: nil)
      return @import unless @import.created_or_failed?

      scan_required = force_scan.nil? ? @import.created? : force_scan
      @import.update(state: :processing)
      initial_context = scan_required ? scan : { success: true }
      initial_context = @importer.before_import(initial_context)
      unless @import.failed?
        rows = process_rows(initial_context)
        ending_context = @importer.after_import(initial_context)
        state = @import.state
        state = :completed if rows.zero?
        state = :failed if ending_context[:success] == false

        messages = ending_context[:messages].try(:join, ', ')

        @import.update(state: state, messages: messages)
      end
      @import
    end

    class << self
      def import_from_file(import_path, import_type)
        import = ::SolidusImporter::Import.new(import_type: import_type)
        import.import_file = import_path
        import.save!
        new(import).process
      end
    end

    private

    def scan
      data = CSV.parse(
        Paperclip.io_adapters.for(@import.file).read.force_encoding(Encoding::UTF_8),
        headers: true,
        encoding: 'UTF-8',
        header_converters: ->(h) { h.strip }
      )
      prepare_rows(data)
    end

    def check_data(data)
      messages = []
      headers = data.headers
      messages << 'Invalid headers' if headers.blank? || !headers.exclude?(nil)
      messages
    end

    def prepare_rows(data)
      messages = check_data(data)
      if messages.empty?
        data.each do |row|
          @import.rows << ::SolidusImporter::Row.new(data: row.to_h)
        end
        { success: true }
      else
        @import.update(state: :failed, messages: messages.join(', '))
        { success: false, messages: messages.join(', ') }
      end
    end

    def process_rows(initial_context)
      rows = @import.rows.created_or_failed.order(id: :asc)
      rows.each do |row|
        ::SolidusImporter::ProcessRow.new(@importer, row).process(initial_context)
      end
      rows.size
    end

    def validate!
      raise ::SolidusImporter::Exception, 'Valid import entity required' if !@import || !@import.valid?
      raise ::SolidusImporter::Exception, "No importer found for #{@import.import_type} type" if !@importer
    end
  end
end
