# frozen_string_literal: true

module SolidusImporter
  module Importers
    class Products < Base
      class << self
        def base_mapping
          {
            'Handle' => nil,
            'Title' => nil,
            'Body (HTML)' => nil,
            'Vendor' => nil,
            'Type' => nil,
            'Tags' => nil,
            'Template Suffix' => nil,
            'Published Scope' => nil,
            'Published' => nil,
            'Published At' => nil,
            'Option1 Name' => nil,
            'Option1 Value' => nil,
            'Option2 Name' => nil,
            'Option2 Value' => nil,
            'Option3 Name' => nil,
            'Option3 Value' => nil,
            'Variant SKU' => nil,
            'Metafields Global Title Tag' => nil,
            'Metafields Global Description Tag' => nil,
            'Metafield Namespace' => nil,
            'Metafield Key' => nil,
            'Metafield Value' => nil,
            'Metafield Value Type' => nil,
            'Variant Grams' => nil,
            'Variant Inventory Tracker' => nil,
            'Variant Inventory Qty' => nil,
            'Variant Inventory Policy' => nil,
            'Variant Fulfillment Service' => nil,
            'Variant Price' => nil,
            'Variant Compare At Price' => nil,
            'Variant Requires Shipping' => nil,
            'Variant Taxable' => nil,
            'Variant Barcode' => nil,
            'Image Attachment' => nil,
            'Image Src' => nil,
            'Image Position' => nil,
            'Image Alt Text' => nil,
            'Variant Image' => nil,
            'Variant Weight' => nil,
            'Variant Weight Unit' => nil,
            'Variant Tax Code' => nil
          }
        end

        def mapping_product
          @mapping_product ||= base_mapping.merge(
            'Handle' => :slug,
            'Title' => :name,
          )
        end

        def mapping_variant
          @mapping_variant ||= base_mapping.merge(
            'Variant SKU' => :sku,
            'Variant Weight' => :weight
          )
        end

        def processors_list
          @processors_list ||= ::SolidusImporter::Config.solidus_importer.dig(:products, :processors) || []
        end
      end
    end
  end
end
