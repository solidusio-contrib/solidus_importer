# frozen_string_literal: true

module SolidusImporter
  class ImportJob < ActiveJob::Base
    queue_as :default

    retry_on ActiveRecord::Deadlocked

    def perform(source, import_type = nil)
      raise ArgumentError, 'Missing import source' unless source

      if source.is_a?(Integer)
        perform_import_from_model(source)
      elsif source.is_a?(String) && import_type.present?
        perform_import_from_filename(source, import_type)
      else
        raise ArgumentError, "#{source} should be a filename or an Import id"
      end
    end

    def perform_import_from_model(id)
      import = ::SolidusImporter::Import.find(id)
      ::SolidusImporter::ProcessImport.new(import).process
    end

    def perform_import_from_filename(filename, import_type)
      ::SolidusImporter::ProcessImport.import_from_file(filename, import_type)
    end
  end
end
