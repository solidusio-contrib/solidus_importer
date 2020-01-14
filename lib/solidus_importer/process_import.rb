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

    def process
      @import.update(state: :processing)
      initial_context = scan
      initial_context = @importer.before_import(initial_context)
      @import.rows.order(id: :asc).each do |row|
        ::SolidusImporter::ProcessRow.new(@importer, row).process(initial_context)
      end
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

    def validate!
      raise ::SolidusImporter::Exception, 'Import required' if !@import
      raise ::SolidusImporter::Exception, "No importer found for #{@import.import_type} type" if !@importer
    end
  end
end
