# frozen_string_literal: true

module Spree
  module Admin
    module SolidusImporter
      class ImportsController < ResourceController
        before_action :assigns_import_types
        after_action :import!, if: -> { @import.valid? }, only: :create

        def index
          @search = ::SolidusImporter::Import.ransack(params[:q])
          @imports = @search.result(distinct: true)
                            .page(params[:page])
                            .per(params[:per_page] || Spree::Config[:orders_per_page])
                            .order(id: :desc)
        end

        def show
          @import = ::SolidusImporter::Import.find(params[:id])
          @search = @import.rows.ransack(params[:q])
          @import_rows = @search.result(distinct: true).page(params[:page]).per(params[:per_page]).order(id: :desc)
        end

        private

        def import!
          ::SolidusImporter::ImportJob.perform_later(@import.id)
        end

        def model_class
          ::SolidusImporter::Import
        end

        def permitted_resource_params
          params.require(:solidus_importer_import).permit(:file, :import_type)
        end

        def assigns_import_types
          @import_types = ::SolidusImporter::Config.available_types
        end
      end
    end
  end
end
