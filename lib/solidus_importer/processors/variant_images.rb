# frozen_string_literal: true

module SolidusImporter
  module Processors
    class VariantImages < Base
      def call(context)
        @data = context.fetch(:data)
        @entity = context.fetch(:entity)
        context.merge!(check_data || save_images)
      end

      private

      def check_data
        if @data['Variant Image'].blank?
          {}
        elsif !@entity || !@entity.is_a?(Spree::Variant) || !@entity.valid?
          { success: false, messages: 'Target entity must be a valid variant' }
        end
      end

      def prepare_image
        Spree::Image.new(
          attachment: File.open(@data['Variant Image'])
        )
      rescue StandardError => e
        @messages = e.message
        nil
      end

      def save_images
        image = prepare_image
        if image
          @entity.images << image
          { success: true }
        else
          { success: false, messages: @messages || entity.errors.full_messages.join(', ') }
        end
      end
    end
  end
end
