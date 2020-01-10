# frozen_string_literal: true

module SolidusImporter
  ##
  # This class process a single row of an import running the configured
  # processor in chain.
  class ProcessRow
    def initialize(importer, row)
      @importer = importer
      @row = row
      validate!
    end

    def process(initial_context)
      context = @importer.processors(@row).each_with_object(initial_context.dup) do |processor, ctx|
        next if ctx[:success] == false && !processor.ensure_call

        ctx.merge! processor.call(ctx)
      end
      @row.update!(
        state: context[:success] ? :completed : :failed,
        messages: context[:messages]
      )
      check_import_finished(context)
      context
    end

    private

    def check_import_finished(context)
      return unless @row.import.finished?

      @importer.after_import(context)
      @row.import.update!(state: (@row.import.rows.failed.any? ? :failed : :completed))
    end

    def validate!
      raise SolidusImporter::Exception, 'No importer defined' if !@importer
      raise SolidusImporter::Exception, 'Invalid row type' if !@row || !@row.is_a?(SolidusImporter::Row)
    end
  end
end
