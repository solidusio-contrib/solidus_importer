# frozen_string_literal: true

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
  end
end
