# frozen_string_literal: true

require 'set'

module SolidusImporter
  class OrderImporter < BaseImporter
    attr_accessor :order_ids

    def initialize(options)
      super
      self.order_ids = Set.new
    end

    def handle_row_import(context)
      order_ids << context[:order]&.id
    end

    def after_import
      Spree::Order.where(id: order_ids).find_each(&:recalculate)
    end
  end
end
