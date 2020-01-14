# frozen_string_literal: true

module SolidusImporter
  module Importers
    class Base
      class << self
        ##
        # Defines a method called before the import process is started.
        # Remember to always return a context with `success` key.
        #
        # - initial_context: context used process the rows, example: `{ success: true }`
        def before_import(initial_context)
          initial_context
        end

        ##
        # Defines a method called after the import process is started
        def after_import(_ending_context); end

        def processors(row)
          processors_list.map { |processor| processor.new(self, row) }
        end

        def processors_list
          []
        end
      end
    end
  end
end
