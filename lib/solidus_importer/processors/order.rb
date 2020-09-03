# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Order < Base
      def call(context)
        @data = context.fetch(:data)

        check_data

        order = context.fetch(:order, {})

        order.merge!(extract_order_attributes)

        context.merge!(order: order)
      end

      def options
        @options ||= {
          store: Spree::Store.default
        }
      end

      private

      def check_data
        raise SolidusImporter::Exception, 'Missing required key: "Name"' if @data['Name'].blank?
      end

      def completed_at
        @data['Processed at'] || @data['Created at']
      end

      def currency
        @data['Currency']
      end

      def email
        @data['Email']
      end

      def extract_order_attributes
        {
          number: number,
          completed_at: completed_at,
          store: options[:store],
          currency: currency,
          email: email,
          special_instructions: special_instruction,
          line_items_attributes: [],
          bill_address_attributes: {},
          ship_address_attributes: {},
          shipments_attributes: [],
          payments_attributes: []
        }
      end

      def number
        @data['Name']
      end

      def special_instruction
        @data['Note']
      end

      def process_order
        prepare_order.tap(&:save!)
      end
    end
  end
end
