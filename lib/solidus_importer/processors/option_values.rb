# frozen_string_literal: true

module SolidusImporter
  module Processors
    class OptionValues < Base
      attr_accessor :option_types, :variant

      def call(context)
        @data = context.fetch(:data)
        return unless option_values?

        self.variant = context.fetch(:variant)
        process_option_values
      end

      private

      def process_option_values
        option_value_names.each_with_index do |name, i|
          next if name.empty?

          option_value = Spree::OptionValue.find_or_initialize_by(
            option_type: option_type(i),
            name: name.parameterize
          )
          option_value.presentation = name
          option_value.save!
          variant.option_values << option_value
          variant.save!
        end
      end

      def option_type(index)
        variant.product.option_types.find { |ot| ot.position == index + 1 }
      end

      def option_value_names
        @option_value_names ||= @data.values_at(
          'Option1 Value',
          'Option2 Value',
          'Option3 Value'
        ).compact
      end

      def option_values?
        # NOTE: according to https://help.shopify.com/en/manual/products/import-export
        # when `Option Value1` is equal to 'Default Title`, means that product has no
        # variants.
        (@data['Option1 Value'] != 'Default Title') && option_value_names.any?
      end
    end
  end
end
