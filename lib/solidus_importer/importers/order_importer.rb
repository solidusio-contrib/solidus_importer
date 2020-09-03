# frozen_string_literal: true

module SolidusImporter
  class OrderImporter < BaseImporter
    def handle_row_result(ending_context)
      context[:imported_orders] ||= []
      context[:imported_orders] << ending_context[:order]
      ending_context
    end
  end
end
