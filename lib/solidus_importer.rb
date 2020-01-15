# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'

require 'solidus_importer/version'
require 'solidus_importer/exception'
require 'solidus_importer/utils'

require 'solidus_importer/importers/base'
importers = File.join(__dir__, 'solidus_importer/importers/*.rb')
Dir[importers].each { |file| require file }

require 'solidus_importer/processors/base'
processors = File.join(__dir__, 'solidus_importer/processors/*.rb')
Dir[processors].each { |file| require file }

require 'solidus_importer/configuration'
require 'solidus_importer/engine'
require 'solidus_importer/process_import'
require 'solidus_importer/process_row'


app = -> env {
  request = Rack::Request.new(env)
  request.get? # => env['GET']
}

class ProcessProduct < Processors::Base
  def call(data)
    parse_decimal(data['Variant Price'])
  end

  def parse_decimal
    …
  end
end

module SolidusImporter
  module ProductProcessors
    PrepareShippingCategory = -> data {
      shipping_category = Spree::ShippingCategory.find_or_create_by(name: 'Default')
      data.merge shipping_category: shipping_category
    }

    ProcessProduct = -> data {
      if data.fetch('Title')
        product = Spree::Product.find_or_initialize_by(slug: data.fetch('Handle'))
        product.name = data.fetch('Title')
        product.shipping_category ||= data.fetch(:shipping_category)
        product.price ||= BigDecimal(data.fetch('Variant Price') || 0)
        product.save!
      else
        product = Spree::Product.find_by!(slug: data.fetch('Handle'))
      end

      data.merge(product: product)
    }

    ProcessVariant = -> data {
      next data unless data['Variant SKU']

      variant = data.fetch(:product).variants.find_or_initialize_by(sku: data['Variant SKU'])
      variant.weight = data['Variant Weight']
      variant.price = BigDecimal(data.fetch('Variant Price') || 0)
      variant.save!

      data.merge(variant: variant)
    }

    ProcessImage = -> data {
      next data unless data['Image Src']
      # TODO
      data
    }
  end

  def self.import_products(csv_file)
    import = Import.create! import_file: csv_file, import_type: :products
    process_import = ProcessImport.new(import, processors: [
      ProductProcessors::PrepareShippingCategory,
      ProductProcessors::ProcessProduct,
      ProductProcessors::ProcessVariant,
    ])
    process_import.process!
    process_import
  end
end
