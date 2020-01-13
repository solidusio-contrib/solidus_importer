# frozen_string_literal: true

require 'csv'

module SolidusImporter
  ##
  # This class parse the source file and create the rows (scan). Then it asks to
  # Process Row to process each one.
  class ProcessImport
    def initialize(import)
      @import = import
      @importer = ::SolidusImporter::Config.solidus_importer.dig(@import.import_type.to_sym, :importer)
      validate!
    end

    def process(force_scan: nil)
      return false unless @import.created_or_failed?

      scan_required = force_scan.nil? ? @import.created? : force_scan
      @import.update(state: :processing)
      initial_context = scan_required ? scan : { success: true }
      initial_context = @importer.before_import(initial_context)
      rows = process_rows(initial_context)
      @import.update(state: :completed) if rows.zero?
      true
    end

    private

    def scan
      data = CSV.parse(
        File.read(@import.file.path),
        headers: true,
        encoding: 'UTF-8',
        header_converters: ->(h) { h.strip }
      )
      check_data(data)
      prepare_rows(data)
      { success: true }
    end

    def check_data(data)
      headers = data.headers
      @import.update(state: :failed, messages: 'Invalid headers') if headers.blank? || !headers.exclude?(nil)
    end

    def prepare_rows(data)
      data.each do |row|
        @import.rows << ::SolidusImporter::Row.new(data: row.to_h)
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
