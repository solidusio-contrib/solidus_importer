# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Variant < Base
      def call(context)
        @data = context[:data]
        @product = context[:product]
        context.merge!(check_data || save_variant)
      end

      private

      def check_data
        if @data.blank?
          { success: false, messages: 'Missing input data' }
        elsif @data['Variant SKU'].blank?
          {}
        elsif !@product
          { success: false, messages: 'Missing product' }
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
    end
  end
end
