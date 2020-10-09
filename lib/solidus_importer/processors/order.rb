# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Order < Base
      def call(context)
        @data = context.fetch(:data)
        check_data
        context.merge!(order: order_attributes)
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
        processed_at = @data['Processed At']
        processed_at ? Time.parse(processed_at).in_time_zone : Time.current
      rescue ArgumentError
        Time.current
      end

      def currency
        @data['Currency']
      end

      def email
        @data['Email']
      end

      def order_attributes
        {
          number: number,
          completed_at: completed_at,
          store: options[:store],
          currency: currency,
          email: email,
          user: user,
          special_instructions: special_instruction,
          line_items_attributes: {},
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

      def user
        @user ||= Spree::User.find_by(email: email)
      end
    end
  end
end
