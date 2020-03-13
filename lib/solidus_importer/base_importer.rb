# frozen_string_literal: true

module SolidusImporter
  class BaseImporter
    attr_reader :options, :logger

    def initialize(options)
      @options = options
      @logger ||= begin
        if @options[:logger] && !@options[:logger].is_a?(Class)
          @options[:logger]
        else
          (@options[:logger] || ::SolidusImporter::BaseLogger).new
        end
      end
    end

    def processors
      @options[:processors] || []
    end

    ##
    # Defines a method called before the import process is started.
    # Remember to always return a context with `success` key.
    #
    # - initial_context: context used process the rows, example: `{ success: true }`
    def before_import(initial_context)
      initial_context
    end

    ##
    # Defines a method called when a process row fails
    def process_row_failure(_processor, context:, error:); end

    ##
    # Defines a method called after the import process is started
    def after_import(_ending_context); end
  end
end
