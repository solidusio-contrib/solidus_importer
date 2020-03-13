# frozen_string_literal: true

module SolidusImporter
  class Log
    attr_reader :context, :source

    def initialize(source:, context:)
      @source = source
      @context = context
    end

    def inspect
      "#{source}: #{context}"
    end
  end
end
