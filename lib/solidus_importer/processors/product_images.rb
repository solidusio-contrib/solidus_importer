# frozen_string_literal: true

module SolidusImporter
  module Processors
    class ProductImages < Base
      def call(context)
        @data = context.fetch(:data)
        @entity = context.fetch(:entity)
        context.merge!(check_data || save_images)
      end

      private

      def check_data
        if @data['Image Src'].blank?
          {}
        elsif !@entity || !@entity.is_a?(Spree::Product) || !@entity.valid?
          { success: false, messages: 'Target entity must be a valid product' }
        end
      end

      def prepare_image
        Spree::Image.new(
          attachment: File.open(@data['Image Src']),
          alt: @data['Alt Text']
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
