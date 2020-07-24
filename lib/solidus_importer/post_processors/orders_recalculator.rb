# frozen_string_literal: true

module SolidusImporter
  module PostProcessors
    class OrdersRecalculator < SolidusImporter::Processors::Base
      def call(ending_context)
        ending_context[:orders].each do |order|
          order.becomes(Spree::Order).recalculate
        end
      end
    end
  end
end
