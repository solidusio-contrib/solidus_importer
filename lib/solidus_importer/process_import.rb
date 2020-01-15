# frozen_string_literal: true

require 'csv'

module SolidusImporter
  ##
  # This class parse the source file and create the rows (scan). Then it asks to
  # Process Row to process each one.
  class ProcessImport
    attr_reader :data

    def initialize(import, processors:)
      @import = import
      @processors = processors
      @data = CSV.parse(
        File.read(@import.file.path),
        headers: true,
        encoding: 'UTF-8',
        header_converters: ->(h) { h.strip }
      )
    end

    def process!
      @import.update(state: :processing)
      check_data(data)
      prepare_rows(data)

      @import.rows.order(id: :asc).each do |row|
        p process_row!(row)
      end
    end

    def process_row!(row)
      @processors.reduce(row.data) do |data, processor|
        processor.call(data.with_indifferent_access)
      end

      data = row.data
      @processors.each do |processor|
        data = processor.call(data.with_indifferent_access)
      end

      # @processors.each_with_object(row.data) do |processor, data|
      #   data.merge! processor.call(data.with_indifferent_access)
      # end
    end

    private

    def check_data(data)
      headers = data.headers
      @import.update(state: :failed, messages: 'Invalid headers') if headers.blank? || !headers.exclude?(nil)
    end

    def prepare_rows(data)
      data.each.with_index do |row, index|
        @import.rows << ::SolidusImporter::Row.new(data: row.to_h.merge(index: index))
      end
    end
  end
end
