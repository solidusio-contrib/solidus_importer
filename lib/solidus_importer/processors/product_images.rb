# frozen_string_literal: true

module SolidusImporter
  module Processors
    class ProductImages < Base
      def call(context)
        @data = context.fetch(:data)
        return unless product_image?

        product = context.fetch(:product)
        process_images(product)
      end

      private

      def prepare_image
        attachment = URI.open(@data['Image Src'])
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
