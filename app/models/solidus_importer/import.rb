# frozen_string_literal: true

module SolidusImporter
  class Import < ApplicationRecord
    self.table_name = 'solidus_importer_imports'

    attr_accessor :importer

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

    def self.ransackable_attributes(_auth_object = nil)
      ["created_at", "file", "file_content_type", "file_file_name", "file_file_size", "file_updated_at", "id", "id_value", "import_type", "messages", "state", "updated_at"]
    end

    class << self
      def available_types
        SolidusImporter::Import.select(:import_type).order(:import_type).group(:import_type).pluck(:import_type)
      end
    end
  end
end
