# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Order < Base
      def call(context)
        @data = context.fetch(:data)
        check_data
        context.merge!(order: process_order)
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

      def prepare_order
        Spree::Order.find_or_initialize_by(number: @data['Name']) do |order|
          order.store = options[:store]
        end.tap do |order|
          # Apply the row attributes
          order.currency = @data['Currency'] unless @data['Currency'].nil?
          order.email = @data['Email'] unless @data['Email'].nil?
          order.special_instructions = @data['Note'] unless @data['Note'].nil?
        end
      end

      def process_order
        prepare_order.tap(&:save!)
      end
    end
  end
end
