# frozen_string_literal: true

require 'solidus_importer/csv_format_validators/empty_headers'

SolidusImporter.configure do |config|
  # TODO: Remember to change this with the actual preferences you have implemented!
  # config.sample_preference = 'sample_value'

  # By default, the imported CSV data is validated to have headers that exist and are not blank.
  config.csv_format_validators = [SolidusImporter::CsvFormatValidators::EmptyHeaders]
end
