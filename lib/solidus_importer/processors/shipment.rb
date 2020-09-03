# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Shipment < Base
      attr_accessor :order

      def call(context)
        @data = context.fetch(:data)

        self.order = context.fetch(:order, {})

        order[:shipments_attributes] ||= []
        order[:shipments_attributes] << shipments_attributes

        context.merge!(order: order)
      end

      def cost
        @data['Shipping Line Price'] || 0
      end

      def inventory_units
        line_items_attributes.map do |line_item|
          { sku: line_item[:sku] }
        end
      end

      def line_items_attributes
        order.fetch(:line_items_attributes, [])
      end

      def shipments_attributes
        {
          shipped_at: shipped_at,
          shipping_method: shipping_method_name,
          stock_location: stock_location.name,
          inventory_units: inventory_units,
          cost: cost
        }
      end

      def shipped_at
        Time.zone.now if fulfillment_status == 'fulfilled'
      end

      def fulfillment_status
        @data['Lineitem fulfillment status']
      end

      def shipping_method_name
        #                               default_shipping_method
        @data['Shipping Line Title'] || shipping_method.name
      end
    end
  end
end
