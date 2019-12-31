# frozen_string_literal: true

module Spree
  module Admin
    module SolidusImporter
      class ImportsController < BaseController
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
      end
    end
  end
end
