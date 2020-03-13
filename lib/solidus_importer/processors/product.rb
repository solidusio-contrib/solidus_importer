# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Product < Base
      def call(context)
        @data = context.fetch(:data)
        check_data
        context.merge!(product: process_product)
      end

      def options
        @options ||= {
          price: 0,
          shipping_category: Spree::ShippingCategory.find_by(name: 'Default') || Spree::ShippingCategory.first
        }
      end

      private

      def check_data
        raise SolidusImporter::Exception, 'Missing required key: "Handle"' if @data['Handle'].blank?
      end

      def prepare_product
        Spree::Product.find_or_initialize_by(slug: @data['Handle']) do |product|
          product.slug = @data['Handle']
          product.price = options[:price]
          product.shipping_category = options[:shipping_category]
        end.tap do |product|
          # Apply the row attributes
          product.name = @data['Title'] unless @data['Title'].nil?
        end
      end

      def process_product
        if @data['Variant SKU'].present?
          Spree::Product.find_by!(slug: @data['Handle'])
        else
          prepare_product.tap(&:save!)
        end
      end
    end
  end
end
