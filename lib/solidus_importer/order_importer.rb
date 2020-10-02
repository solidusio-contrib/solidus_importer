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

      order_params = context[:order].to_h.reject { |_k, v| v.blank? }
      orders[number] ||= {}
      orders[number].merge!(order_params)
    end

    def after_import
      orders.each do |_, params|
        user = params.delete(:user)
        Spree::Core::Importer::Order.import(user, params)
      end
    end
  end
end
