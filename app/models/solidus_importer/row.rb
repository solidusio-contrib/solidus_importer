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

    def self.ransackable_attributes(_auth_object = nil)
      ["created_at", "data", "id", "id_value", "import_id", "messages", "state", "updated_at"]
    end
  end
end
