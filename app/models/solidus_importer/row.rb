# frozen_string_literal: true

module SolidusImporter
  class Row < ApplicationRecord
    self.table_name = 'solidus_importer_rows'

    belongs_to :import,
      class_name: 'SolidusImporter::Import',
      inverse_of: :rows

    serialize :data, JSON

    enum state: {
      created: 'created',
      processing: 'processing',
      failed: 'failed',
      completed: 'completed'
    }

    scope :created_or_failed, -> { where(state: %i[created failed]) }
    scope :failed_or_completed, -> { where(state: %i[failed completed]) }

    validates :data, presence: true, allow_blank: false
    validates :state, presence: true, allow_blank: false

    before_create :infer_entity_id_from_data

    def infer_entity_id_from_data
      self.entity_id = data['Name'] || data['Email'] || data['Handle']
    end
  end
end
