# frozen_string_literal: true

module SolidusImporter
  module Processors
    class VariantImages < Base
      def call(context)
        @data = context.fetch(:data)
        return unless variant_image?

        variant = context.fetch(:variant)
        process_images(variant)
      end

      private

      def prepare_image
        attachment = URI.parse(@data['Variant Image']).open
        Spree::Image.new(attachment: attachment)
      end

      def process_images(variant)
        variant.images << prepare_image
      end

      def variant_image?
        @variant_image ||= @data['Variant Image'].present?
      end
    end
  end
end
