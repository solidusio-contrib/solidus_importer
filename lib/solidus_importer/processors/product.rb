# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Product < Base
      def call(_context)
        return @errors unless validate_row.nil?

        @product = load_product
        return { product: @product } if @row.data['Variant SKU'].present?

        save_product
      end

      def options
        @options ||= {
          price: 0,
          shipping_category: Spree::ShippingCategory.find_by(name: 'Default') || Spree::ShippingCategory.first
        }
      end

      private

      def attrs
        @attrs ||= extract_attrs(@row.data, mapping)
      end

      def load_product
        Spree::Product.find_by(slug: attrs[:slug])
      end

      def mapping
        @importer.mapping_product
      end

      def save_product
        @product ||= Spree::Product.new do |prod|
          prod.slug = attrs[:slug]
          prod.price = options[:price]
          prod.shipping_category = options[:shipping_category]
        end
        @new_record = @product.new_record?
        update_context(@product, prepare_product && @product.save)
      end

      def prepare_product
        @product.assign_attributes(attrs)
        true
      rescue StandardError => e
        @messages = e.message
        false
      end

      def validate_row
        @errors =
          if !@row.is_a?(SolidusImporter::Row)
            { success: false, messages: 'Invalid row type' }
          elsif invalid_keys.any?
            { success: false, messages: 'Invalid keys in row data' }
          end
      end
    end
  end
end
