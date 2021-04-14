# frozen_string_literal: true

module SolidusImporter
  module Processors
    class ProductStore
      def call(context)
        product = context.fetch(:product) || raise(ArgumentError, 'missing :product in context')
        store = Spree::Store.default
        product.update!(store: store)

        context.merge!(store: store)
      end
    end
  end
end
