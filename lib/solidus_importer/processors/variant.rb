# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Variant < Base
      def call(context)
        @data = context.fetch(:data)
        @product = context.fetch(:product) if variant?
        context.merge!(check_data || save_variant)
      end

      private

      def check_data
        if @data.blank?
          { success: false, messages: 'Missing input data' }
        elsif !variant?
          {}
        elsif !@product&.valid?
          { success: false, messages: 'Parent entity must be a valid product' }
        end
      end

      def prepare_variant
        variant = Spree::Variant.find_or_initialize_by(sku: @data['Variant SKU']) do |var|
          var.product = @product
        end
        variant.weight = @data['Variant Weight'] unless @data['Variant Weight'].nil?
        variant
      end

      def save_variant
        variant = prepare_variant
        prepare_context(entity: variant, new_record: variant.new_record?, success: variant.save)
      end

      def variant?
        @variant ||= (@data && @data['Variant SKU'].present?)
      end
    end
  end
end
