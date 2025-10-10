# frozen_string_literal: true

module SolidusImporter
  module Tax
    class NullOrderAdjuster
      attr_reader :order

      def initialize(order)
        @order = order
      end

      def adjust!
      end
    end
  end
end
