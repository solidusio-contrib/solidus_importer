# frozen_string_literal: true

module SolidusImporter
  class OrderUpdater < Spree::OrderUpdater
    # Override this method to avoid tax calculation
    def update_taxes; end
  end
end
