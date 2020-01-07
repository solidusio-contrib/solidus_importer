# frozen_string_literal: true

module SolidusImporter
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'solidus_importer'

    # use rspec for tests
    config.generators do |g|
      g.test_framework(:rspec)
    end
  end
end
