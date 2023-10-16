# frozen_string_literal: true

require_relative 'csv_format_validators/empty_headers'

module SolidusImporter
  class Configuration < Spree::Preferences::Configuration
    preference :solidus_importer, :hash, default: {
      customers: {
        importer: SolidusImporter::BaseImporter,
        processors: [
          SolidusImporter::Processors::Customer,
          SolidusImporter::Processors::CustomerAddress,
          SolidusImporter::Processors::Log
        ]
      },
      orders: {
        importer: SolidusImporter::OrderImporter,
        processors: [
          SolidusImporter::Processors::Order,
          SolidusImporter::Processors::BillAddress,
          SolidusImporter::Processors::ShipAddress,
          SolidusImporter::Processors::LineItem,
          SolidusImporter::Processors::Shipment,
          SolidusImporter::Processors::Payment,
          SolidusImporter::Processors::Log
        ]
      },
      products: {
        importer: SolidusImporter::BaseImporter,
        processors: [
          SolidusImporter::Processors::Product,
          SolidusImporter::Processors::Variant,
          SolidusImporter::Processors::OptionTypes,
          SolidusImporter::Processors::OptionValues,
          SolidusImporter::Processors::ProductImages,
          SolidusImporter::Processors::VariantImages,
          SolidusImporter::Processors::Log
        ]
      }
    }

    def available_types
      solidus_importer.keys
    end

    # Solidus's preferences assume that if the default value is a Proc/lambda
    # that it should be called to return the actual default value. In order to
    # set a default value that is itself a Proc, you must wrap it in another
    # Proc. This only applies to the default value and this preference can be
    # set normally, by assigning the Proc directly.
    #
    # Additionally, some versions of Solidus will pass in the version as an
    # argument. Using a lambda will verify that the correct number of arguments
    # are passed, whereas using a plain Proc won't.
    preference :row_exception_handler, :callable, default: proc { ->(exception, context) {} }

    # An array of callables that will validate the imported data after it has
    # been parsed and before it is imported. A validation message should be
    # returned on failure, otherwise `nil` should be returned on success.
    # The default value for this preference is set in the `solidus_importer.rb`
    # initializer file.
    #
    # A `CSV::Table` object will be passed to the callable, e.g.
    # SolidusImporter::Config.csv_format_validators = [
    #   ->(csv_table) do
    #     headers = csv_table.headers
    #     if headers.blank? || !headers.exclude?(nil)
    #       'Invalid headers'
    #     end
    #   end
    # ]
    preference :csv_format_validators, :array, default: [::SolidusImporter::CsvFormatValidators::EmptyHeaders]
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    alias config configuration

    def configure
      yield configuration
    end
  end
end
