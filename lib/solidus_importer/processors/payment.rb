# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Payment < Base
      attr_accessor :order

      def call(context)
        @data = context.fetch(:data)

        self.order = context.fetch(:order, {})

        order[:payments_attributes] ||= []
        order[:payments_attributes] << payments_attributes

        context.merge!(order: order)
      end

      def amount
        @data['Total'] || calculate_total
      end

      def calculate_total
        order.fetch(:line_items_attributes).sum { |li| li.fetch(:price, 0) }
      end

      def payments_attributes
        { payment_method: payment_method.name, amount: amount }
      end

      def payment_method
        @payment_method ||= Spree::PaymentMethod.find_or_initialize_by(
          name: 'SolidusImporter PaymentMethod',
          type: 'Spree::PaymentMethod::Check'
        ).tap(&:save)
      end
    end
  end
end
