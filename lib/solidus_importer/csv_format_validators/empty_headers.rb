# frozen_string_literal: true

module SolidusImporter
  module CsvFormatValidators
    class EmptyHeaders
      def self.call(csv_table)
        headers = csv_table.headers
        return unless headers.blank? || !headers.exclude?(nil)

        'Invalid headers'
      end
    end
  end
end
