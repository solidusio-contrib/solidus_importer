# frozen_string_literal: true

module SolidusImporter
  module Processors
    class VariantImages < Base
      def call(context)
        @data = context.fetch(:data)
        @variant = context.fetch(:variant) if variant_image?
        context.merge!(check_data || save_images)
      end

      private

      def check_data
        if !variant_image?
          {}
        elsif !@variant || !@variant.valid?
          { success: false, messages: 'Target entity must be a valid variant' }
        end
      end

      def prepare_image
        attachment = URI.open(@data['Variant Image'])
        Spree::Image.new(attachment: attachment)
      rescue StandardError => e
        @messages = e.message
        nil
      end

      def save_images
        image = prepare_image
        if image
          @variant.images << image
          { success: true }
        else
          { success: false, messages: @messages || @variant.errors.full_messages.join(', ') }
        end
      end

      def variant_image?
        @data['Variant Image'].present?
      end
    end
  end
end
