# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Log
      def initialize(_importer, row)
        @row = row
      end

      def call(context)
        Spree::LogEntry.create!(source: @row, details: context.to_json)
        {}
      end

      def ensure_call
        true
      end
    end
  end
end
