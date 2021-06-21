# frozen_string_literal: true

require_relative 'line_item'

module SolidusImporter
  module Processors
    class Payment < Base
      attr_accessor :order

      def call(context)
        @data = context.fetch(:data)

        return unless amount > 0

        self.order = context.fetch(:order, {})

        order[:payments_attributes] = payment_attributes

        context.merge!(order: order)
      end

      private

      def amount
        price * quantity
      end

      def price
        @data['Lineitem price'].to_f
      end

      def quantity
        @data['Lineitem quantity'].to_i
      end

      def financial_status
        @data['Financial Status'].to_s.inquiry
      end

      def payment_attributes
        {
          payment_method: payment_method.name,
          amount: amount
        }
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
