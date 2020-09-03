# frozen_string_literal: true

module SolidusImporter
  class OrderImporter < BaseImporter
    def handle_row_result(ending_context)
      context[:imported_order_ids] ||= []
      context[:imported_order_ids] << ending_context[:order]&.id
    end
  end
end
