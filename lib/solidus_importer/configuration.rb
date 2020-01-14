# frozen_string_literal: true

module SolidusImporter
  class Configuration < Spree::Preferences::Configuration
    preference :solidus_importer, :hash, default: {
      customers: {
        importer: SolidusImporter::Importers::Customers,
        processors: [
          SolidusImporter::Processors::Customer,
          SolidusImporter::Processors::Log
        ]
      },
      orders: {
        importer: SolidusImporter::Importers::Orders,
        processors: [
          SolidusImporter::Processors::Order,
          SolidusImporter::Processors::Log
        ]
      },
      products: {
        importer: SolidusImporter::Importers::Products,
        processors: [
          SolidusImporter::Processors::Product,
          SolidusImporter::Processors::Variant,
          SolidusImporter::Processors::Log
        ]
      }
    }
  end
end
