# frozen_string_literal: true

module SolidusImporter
  class Configuration < Spree::Preferences::Configuration
    preference :solidus_importer, :hash, default: {
      customers: {
        importer: SolidusImporter::BaseImporter,
        processors: [
          SolidusImporter::Processors::Customer
        ],
        logger: SolidusImporter::SolidusLogger
      },
      orders: {
        importer: SolidusImporter::BaseImporter,
        processors: [
          SolidusImporter::Processors::Order
        ],
        logger: SolidusImporter::SolidusLogger
      },
      products: {
        importer: SolidusImporter::BaseImporter,
        processors: [
          SolidusImporter::Processors::Product,
          SolidusImporter::Processors::Variant,
          SolidusImporter::Processors::ProductImages,
          SolidusImporter::Processors::VariantImages
        ],
        logger: SolidusImporter::SolidusLogger
      }
    }
  end
end
