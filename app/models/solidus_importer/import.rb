# frozen_string_literal: true

module SolidusImporter
  class Import < ApplicationRecord
    self.table_name = 'solidus_importer_imports'

    has_many :rows,
      class_name: 'SolidusImporter::Row',
      inverse_of: :import,
      dependent: :destroy

    enum state: {
      created: 'created',
      processing: 'processing',
      failed: 'failed',
      completed: 'completed'
    }

    has_attached_file :file

    do_not_validate_attachment_file_type :file
    validates_attachment_presence :file
    validates :import_type, presence: true, allow_blank: false
    validates :state, presence: true, allow_blank: false

    def created_or_failed?
      %w[created failed].include? state
    end

    def finished?
      rows.failed_or_completed.size == rows.size
    end

    def import_file=(path)
      raise SolidusImporter::Exception, 'Existing file required' if !path || !File.exist?(path)

      self.file = File.open(path, 'r')
    end
  end
end
