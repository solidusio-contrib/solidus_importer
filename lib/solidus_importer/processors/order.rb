# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Order < Base
      delegate :mapping, to: :@importer

      def call(_context)
        return @errors unless validate_row.nil?

        save_order
      end

      def options
        @options ||= {
          store: Spree::Store.default
        }
      end

      private

      def attrs
        @attrs ||= extract_attrs(@row.data, mapping)
      end

      def save_order
        @order = Spree::Order.find_or_initialize_by(number: attrs[:number]) do |ord|
          ord.store = options[:store]
        end
        @new_record = @order.new_record?
        update_context(@order, prepare_order && @order.save)
      end

      def prepare_order
        @order.assign_attributes(attrs)
        true
      rescue StandardError => e
        @messages = e.message
        false
      end

      def validate_row
        @errors =
          if !@row.is_a?(SolidusImporter::Row)
            { success: false, messages: 'Invalid row type' }
          elsif invalid_keys.any?
            { success: false, messages: 'Invalid keys in row data' }
          end
      end
    end
  end
end
