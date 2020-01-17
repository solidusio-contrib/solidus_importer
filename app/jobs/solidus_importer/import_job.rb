# frozen_string_literal: true

module SolidusImporter
  class ImportJob < ActiveJob::Base
    queue_as :default

    retry_on ActiveRecord::Deadlocked

    def perform(import_file, import_type)
      raise ArgumentError, 'Missing import file' unless import_file
      raise ArgumentError, 'Missing import type' unless import_type

      ::SolidusImporter::ProcessImport.import_from_file(import_file, import_type)
    end
  end
end
