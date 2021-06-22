# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Variant < Base
      attr_accessor :product

      def call(context)
        @data = context.fetch(:data)
        self.product = context.fetch(:product) || raise(ArgumentError, 'missing :product in context')

        context.merge!(variant: process_variant)
      end

      private

      def prepare_variant
        return product.master if master_variant?

        @prepare_variant ||= Spree::Variant.find_or_initialize_by(sku: sku) do |variant|
          variant.product = product
        end
      end

      def process_variant
        prepare_variant.tap do |variant|
          # Apply the row attributes
          variant.weight = @data['Variant Weight'] unless @data['Variant Weight'].nil?
          variant.price = @data['Variant Price'] if @data['Variant Price'].present?

          # ensure the sku is properly set (for master sku)
          variant.sku = sku

          # Save the product
          variant.save!
        end
      end

      def master_variant?
        ov1 = @data['Option1 Value']
        ov1.blank? || ov1 == 'Default Title'
      end

      def sku
        @data['Variant SKU'] || generate_sku
      end

      def generate_sku
        variant_part = @data['Option1 Value'].parameterize
        "#{product.slug}-#{variant_part}"
      end
    end
  end
end
