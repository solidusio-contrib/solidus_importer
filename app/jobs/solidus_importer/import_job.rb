# frozen_string_literal: true

module SolidusImporter
  class ImportJob < ActiveJob::Base
    queue_as :default

    retry_on ActiveRecord::Deadlocked

    def perform(import_id)
      raise ArgumentError, 'Missing import id' unless import_id

      import = ::SolidusImporter::Import.find(import_id)
      ::SolidusImporter::ProcessImport.new(import).process
    end
  end
end
