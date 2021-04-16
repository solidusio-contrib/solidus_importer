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

      private

      def cost
        @data['Shipping Line Price'].to_f
      end

      def inventory_units
        sku = line_items_attributes[:sku]

        return [] if sku.blank?

        [{ sku: sku }]
      end

      def line_items_attributes
        order.fetch(:line_items_attributes, {})
      end

      def shipments_attributes
        {
          shipped_at: shipped_at,
          shipping_method: shipping_method.name,
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
        @data['Shipping Line Title'] || 'SolidusImporter ShippingMethod'
      end

      def shipping_method
        Spree::ShippingMethod.find_by(name: shipping_method_name) || create_shipping_method
      end

      def create_shipping_method
        shipping_method = Spree::ShippingMethod.new(name: shipping_method_name, calculator: calculator)
        shipping_method.shipping_categories << shipping_category
        shipping_method.save!
        shipping_method
      end

      def calculator
        @calculator ||= Spree::Calculator::FlatRate.find_or_create_by(
          preferences: { amount: 0 }
        )
      end

      def shipping_category
        Spree::ShippingCategory.find_or_create_by(
          name: 'SolidusImporter ShippingCategory'
        )
      end

      def stock_location
        @stock_location ||= Spree::StockLocation.find_or_create_by(
          name: 'SolidusImporter StockLocation'
        )
      end
    end
  end
end
