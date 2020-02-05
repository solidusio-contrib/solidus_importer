# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Variant < Base
      def call(context)
        @data = context.fetch(:data)
        return unless variant?

        product = context.fetch(:product)
        variant = process_variant(product)
        context.merge!(variant: variant)
      end

      private

      def prepare_variant(product)
        Spree::Variant.find_or_initialize_by(sku: @data['Variant SKU']) do |variant|
          variant.product = product
        end.tap do |variant|
          # Apply the row attributes
          variant.weight = @data['Variant Weight'] unless @data['Variant Weight'].nil?
        end
      end

      def process_variant(product)
        prepare_variant(product).tap(&:save!)
      end

      def variant?
        @variant ||= @data['Variant SKU'].present?
      end
    end
  end
end
