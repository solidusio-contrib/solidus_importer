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
        attachment = @data['Variant Image']
        image = Spree::Image.new

        if attachment.match?(/^http/)
          io = URI.parse(attachment).open
          io.define_singleton_method(:to_path) do
            File.basename(URI.parse(attachment).path)
          end
        elsif File.exist?(attachment)
          io = File.open(attachment)
        else
          raise URI::InvalidURIError, "bad URI #{attachment}"
        end

        image.tap { |i| i.attachment = io }
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
