# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Base
      def options
        {}
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
