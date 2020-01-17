# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Order < Base
      def call(context)
        @data = context[:data]
        context.merge!(check_data || save_order)
      end

      def options
        @options ||= {
          store: Spree::Store.default
        }
      end

      private

      def check_data
        if @data.blank?
          { success: false, messages: 'Missing input data' }
        elsif @data['Name'].blank?
          { success: false, messages: 'Missing required key: "Name"' }
        end
      end

      def prepare_order
        order = Spree::Order.find_or_initialize_by(number: @data['Name']) do |ord|
          ord.store = options[:store]
        end
        order.currency = @data['Currency'] unless @data['Currency'].nil?
        order.email = @data['Email'] unless @data['Email'].nil?
        order.special_instructions = @data['Note'] unless @data['Note'].nil?
        order
      end

      def save_order
        order = prepare_order
        prepare_context(entity: order, new_record: order.new_record?, success: order.save)
      end
    end
  end
end
