# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Base
      include ::SolidusImporter::Utils

      def initialize(importer, row)
        @importer = importer
        @row = row
        @errors = nil
        @messages = nil
        @new_record = false
      end

      def invalid_keys
        (@row.data&.keys || []) - (mapping&.keys || [])
      end

      def options
        {}
      end

      def update_context(entity, saved)
        {
          id: entity.id,
          class_name: entity.class.name,
          new_record: @new_record
        }.merge(
          if saved
            { success: true }
          else
            { success: false, messages: @messages || entity.errors.full_messages.join(', ') }
          end
        )
      end

      def ensure_call
        false
      end
    end
  end
end
