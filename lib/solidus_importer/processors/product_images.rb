# frozen_string_literal: true

module SolidusImporter
  module Processors
    class ProductImages < Base
      class URIParser
        def self.parse(uri)
          URI.parse(uri)
        end
      end

      def call(context)
        @data = context.fetch(:data)
        return unless product_image?

        product = context.fetch(:product)
        process_images(product)
      end

      private

      def prepare_image
        attachment = URIParser.parse(@data['Image Src']).open
        Spree::Image.new(attachment: attachment, alt: @data['Alt Text'])
      end

      def process_images(product)
        product.images << prepare_image
      end

      def product_image?
        @product_image ||= @data['Image Src'].present?
      end
    end
  end
end
