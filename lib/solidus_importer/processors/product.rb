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
          available_on: Date.current.yesterday,
          not_available: nil,
          price: 0,
          shipping_category: Spree::ShippingCategory.find_by(name: 'Default') || Spree::ShippingCategory.first
        }
      end

      private

      def check_data
        raise SolidusImporter::Exception, 'Missing required key: "Handle"' if @data['Handle'].blank?
      end

      def prepare_product
        Spree::Product.find_or_initialize_by(slug: @data['Handle'])
      end

      def process_product
        prepare_product.tap do |product|
          product.slug = @data['Handle']
          product.price = options[:price]
          product.available_on = available? ? options[:available_on] : options[:not_available]
          product.shipping_category = options[:shipping_category]

          product.name = @data['Title'] unless @data['Title'].nil?
          product.description = @data['Body (HTML)'] || ''

          product.save!
        end
      end

      def available?
        @data['Published'] == 'true'
      end
    end
  end
end
