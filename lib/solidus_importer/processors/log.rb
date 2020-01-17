# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Log < Base
      def call(context)
        Spree::LogEntry.create!(
          source_id: context[:row_id],
          source_type: 'SolidusImporter::Row',
          details: context.to_json
        )
      end

      class << self
        def ensure_call
          true
        end
      end
    end
  end
end
