# frozen_string_literal: true

module SolidusImporter
  class ProcessRowGroupJob < ApplicationJob
    queue_as { SolidusImporter.configuration.processing_queue }

    def perform(import_id, row_ids)
      import = SolidusImporter::Import.find(import_id)
      rows = SolidusImporter::Row.where(id: row_ids).all

      options = ::SolidusImporter::Config.solidus_importer[import.import_type.to_sym]
      @importer = options[:importer].new(options)

      context = { success: true }

      rows.each do |row|
        context = SolidusImporter::ProcessRow.new(@importer, row).process(context)
      end

      @importer.after_group_import(import, context)

      import.finish! if import.finished_all_rows?
    end
  end
end
