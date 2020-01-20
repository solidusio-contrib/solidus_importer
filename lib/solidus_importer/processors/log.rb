# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Log < Base
      def call(context)
        entity = context[:entity]
        extra_fields = { entity_class: entity&.class&.name, entity_id: entity&.id }
        Spree::LogEntry.create!(
          source_id: context[:row_id],
          source_type: 'SolidusImporter::Row',
          details: context.except(:entity, :importer, :data).merge(extra_fields).to_json
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
