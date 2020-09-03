# frozen_string_literal: true

module SolidusImporter
  module Processors
    class LineItem < Base
      def call(context)
        @data = context[:data]

        line_items_attributes.empty? and return

        order = context.fetch(:order, {})

        index = order[:line_items_attributes]&.size || 0

        order[:line_items_attributes] ||= {}
        order[:line_items_attributes][index] = line_items_attributes

        context.merge!(order: order)
      end

      private

      def line_items_attributes
        { sku: sku, quantity: quantity, price: price }
      end

      def price
        @data['Lineitem price']
      end

      def quantity
        @data['Lineitem quantity']
      end

      def sku
        @data['Lineitem sku']
      end
    end
  end
end
