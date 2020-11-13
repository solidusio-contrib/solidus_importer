# frozen_string_literal: true

module SolidusImporter
  module Processors
    class OptionTypes < Base
      def call(context)
        @data = context.fetch(:data)
        return unless option_types?

        product = context.fetch(:product)
        context.merge!(option_types: process_option_types(product))
      end

      private

      def process_option_types(product)
        option_type_names.each_with_index.map do |name, i|
          option_type = Spree::OptionType.find_or_initialize_by(name: name.downcase)
          option_type.presentation ||= name
          option_type.position = i + 1
          option_type.save
          product.option_types << option_type unless product.option_types.include?(option_type)
        end
      end

      def option_type_names
        @option_type_names ||= @data.values_at(
          'Option1 Name',
          'Option2 Name',
          'Option3 Name'
        ).compact
      end

      def option_types?
        # NOTE: according to https://help.shopify.com/en/manual/products/import-export
        # when `Option Name1` is equal to 'Title`, means that product has no variants.
        (@data['Option1 Name'] != 'Title') && option_type_names.any?
      end
    end
  end
end
