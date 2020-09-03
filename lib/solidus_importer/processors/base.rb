# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Base
      def options
        {}
      end

      def shipping_method
        @shipping_method ||= Spree::ShippingMethod.find_or_create_by(
          name: 'SolidusImporter ShippingMethod',
          calculator: calculator,
        ).tap do |sm|
          sm.shipping_categories << shipping_category
          sm.save!
        end
      end

      def calculator
        @calculator ||= Spree::Calculator::FlatRate.find_or_create_by(
          preferences: { amount: 0 }
        )
      end

      def shipping_category
        Spree::ShippingCategory.find_or_create_by(
          name: 'SolidusImporter ShippingCategory'
        )
      end

      def stock_location
        @stock_location ||= Spree::StockLocation.find_or_create_by(
          name: 'SolidusImporter StockLocation'
        )
      end

      class << self
        delegate :call, to: :new
      end
    end
  end
end
