# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Base
      def options
        {}
      end

      def prepare_context(entity:, new_record:, success:)
        if success
          {
            success: true,
            entity: entity,
            new_record: new_record
          }
        else
          {
            success: false,
            messages: @messages || entity.errors.full_messages.join(', ')
          }
        end
      end

      class << self
        delegate :call, to: :new

        def ensure_call
          false
        end
      end
    end
  end
end
