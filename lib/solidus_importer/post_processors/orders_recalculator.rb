# frozen_string_literal: true

module SolidusImporter
  module PostProcessors
    class OrdersRecalculator < SolidusImporter::Processors::Base
      def call(ending_context)
        (ending_context[:imported_order_ids] || []).each do |id|
          Spree::Order.find(id).recalculate
        end
      end
    end
  end
end
