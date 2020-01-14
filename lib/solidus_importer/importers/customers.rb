# frozen_string_literal: true

module SolidusImporter
  module Importers
    class Customers < Base
      class << self
        def mapping
          @mapping ||= {
            'First Name' => nil,
            'Last Name' => nil,
            'Email Address' => :email
          }
        end

        def processors_list
          @processors_list ||= ::SolidusImporter::Config.solidus_importer.dig(:customers, :processors) || []
        end
      end
    end
  end
end
