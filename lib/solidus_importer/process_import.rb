# frozen_string_literal: true

require 'csv'

module SolidusImporter
  ##
  # This class parses the source file and creates the rows (scan)
  # Then it processes the Rows grouping by their `entity_id`, by default in the background
  class ProcessImport
    # this in injected mostly to make testing this class more easily.
    DEFAULT_GROUP_PROCESSOR = ->(import, row_ids) {
      ::SolidusImporter::ProcessRowGroupJob.perform_later(import.id, row_ids)
    }

    def initialize(import, importer_options: nil, group_processor: DEFAULT_GROUP_PROCESSOR)
      @import = import
      @group_processor = group_processor
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
        queue_process_rows(initial_context)
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

    attr_reader :importer

    def scan
      data = CSV.parse(
        File.read(@import.file.path),
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

    def queue_process_rows(initial_context)
      group_of_rows = @import.rows.created_or_failed.order(id: :asc).group_by(&:entity_id)
      group_of_rows.each do |(_, group)|
        row_ids = group.map(&:id)
        @group_processor.call(@import, row_ids)
      end
    end

    def validate!
      raise ::SolidusImporter::Exception, 'Valid import entity required' if !@import || !@import.valid?
      raise ::SolidusImporter::Exception, "No importer found for #{@import.import_type} type" if !@importer
    end
  end
end
