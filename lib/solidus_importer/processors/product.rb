# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Product < Base
      def call(context)
        @data = context.fetch(:data)
        context.merge!(check_data || save_product)
      end

      def options
        @options ||= {
          price: 0,
          shipping_category: Spree::ShippingCategory.find_by(name: 'Default') || Spree::ShippingCategory.first
        }
      end

      private

      def check_data
        if @data.blank?
          { success: false, messages: 'Missing input data' }
        elsif @data['Handle'].blank?
          { success: false, messages: 'Missing required key: "Handle"' }
        elsif @data['Variant SKU'].present?
          { product: load_product }
        end
      end

      def load_product
        Spree::Product.find_by(slug: @data['Handle'])
      end

      def prepare_product
        product = load_product || Spree::Product.new do |prod|
          prod.slug = @data['Handle']
          prod.price = options[:price]
          prod.shipping_category = options[:shipping_category]
        end
        product.name = @data['Title'] unless @data['Title'].nil?
        product
      end

      def save_product
        product = prepare_product
        {
          new_record: product.new_record?,
          success: product.save,
          product: product,
          messages: product.errors.full_messages.join(', ')
        }
      end
    end
  end
end
