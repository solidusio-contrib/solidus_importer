# frozen_string_literal: true

require 'set'

module SolidusImporter
  class OrderImporter < BaseImporter
    attr_accessor :orders

    def initialize(options)
      super
      self.orders = {}
    end

    def handle_row_import(context)
      number = context.dig(:order, :number)

      return unless number

      orders[number] ||= {}

      order_params = context[:order].to_h.reject { |_k, v| v.blank? }

      payments_attributes = order_params.delete(:payments_attributes)
      line_items_attributes = order_params.delete(:line_items_attributes)
      shipment_attributes = order_params.delete(:shipment_attributes)

      orders[number][:payments_attributes] ||= []
      orders[number][:line_items_attributes] ||= {}
      orders[number][:shipments_attributes] ||= []

      index = orders[number][:line_items_attributes].size
      orders[number][:line_items_attributes][index] = line_items_attributes if line_items_attributes.present?

      merge_shipments(orders[number], shipment_attributes) if shipment_attributes.present?

      orders[number][:payments_attributes] << payments_attributes if payments_attributes.present?
      orders[number].merge!(order_params)
    end

    def after_group_import(import, context)
      orders.each do |number, params|
        user = params.delete(:user)
        SolidusImporter::SpreeCoreImporterOrder.import(user, params)
      rescue StandardError => e
        Spree::LogEntry.create!(
          source: import,
          details: "#{number} => #{e.message}"
        )
      end

      context
    end

    private

    def merge_shipments(order_attributes, shipment_attributes)
      shipments_attributes = order_attributes[:shipments_attributes]
      if shipments_attributes.empty?
        shipments_attributes << shipment_attributes
      else
        shipments_attributes.first[:inventory_units].concat(shipment_attributes[:inventory_units])
      end
    end
  end
end
