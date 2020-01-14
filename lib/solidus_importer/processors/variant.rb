# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Variant < Base
      def call(context)
        check = validate(context)
        return check if check

        save_variant(context[:product])
      end

      private

      def attrs
        @attrs ||= extract_attrs(@row.data, mapping)
      end

      def mapping
        @importer.mapping_variant
      end

      def save_variant(product)
        @variant = Spree::Variant.find_or_initialize_by(sku: attrs[:sku]) do |var|
          var.product = product
        end
        @new_record = @variant.new_record?
        update_context(@variant, prepare_variant && @variant.save)
      end

      def prepare_variant
        (attributes = attrs.dup).delete(:product_slug)
        @variant.assign_attributes(attributes)
        true
      rescue StandardError => e
        @messages = e.message
        false
      end

      def validate(context)
        if !@row.is_a?(SolidusImporter::Row)
          { success: false, messages: 'Invalid row type' }
        elsif @row.data['Variant SKU'].blank?
          {}
        elsif invalid_keys.any?
          { success: false, messages: 'Invalid keys in row data' }
        elsif !context || context[:product].nil?
          { success: false, messages: 'Product not found' }
        end
      end
    end
  end
end
