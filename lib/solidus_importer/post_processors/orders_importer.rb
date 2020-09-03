# frozen_string_literal: true

module SolidusImporter
  module PostProcessors
    class OrdersImporter < SolidusImporter::Processors::Base
      def call(ending_context)
        (ending_context[:imported_orders] || []).each do | params|
          begin
            Spree::Core::Importer::Order.import(nil, params)
          rescue StandardError => err
            ending_context.merge!(message: err.message)
          end
        end
      end
    end
  end
end
