# frozen_string_literal: true

module SolidusImporter
  module Processors
    class LineItem < Base
      def call(context)
        @data = context[:data]

        return if @data['Lineitem sku'].blank?

        order = context.fetch(:order, {})
        order[:line_items_attributes] = line_items_attributes

        context.merge!(order: order)
      end

      private

      def line_items_attributes
        {
          sku: @data['Lineitem sku'],
          quantity: @data['Lineitem quantity'],
          price: @data['Lineitem price']
        }
      end
    end
  end
end
