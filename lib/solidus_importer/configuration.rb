# frozen_string_literal: true

module SolidusImporter
  class Configuration < Spree::Preferences::Configuration
    preference :customers, :hash, default: {
      importer: SolidusImporter::BaseImporter,
      processors: [
        SolidusImporter::Processors::Address,
        SolidusImporter::Processors::Customer,
        SolidusImporter::Processors::Log
      ]
    }
    preference :orders, :hash, default: {
      importer: SolidusImporter::BaseImporter,
      processors: [
        SolidusImporter::Processors::Order,
        SolidusImporter::Processors::Log
      ]
    }
    preference :products, :hash, default: {
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
  end
end
