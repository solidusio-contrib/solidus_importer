# frozen_string_literal: true

module Spree
  module Admin
    module SolidusImporter
      class ImportRowsController < BaseController
        before_action :load_data, only: %i[show]

        def show; end

        private

        def load_data
          @import_row = ::SolidusImporter::Row.find_by!(id: params[:id], import_id: params[:import_id])
          return unless (@log_entry = ::Spree::LogEntry.find_by(source: @import_row))

          @log_details = JSON.parse(@log_entry.details)
          target_class = @log_details['class_name']&.constantize
          @target_entity = target_class.find_by(id: @log_details['id']) if target_class
        end
      end
    end
  end
end
