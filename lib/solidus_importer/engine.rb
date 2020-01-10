# frozen_string_literal: true

module SolidusImporter
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'solidus_importer'

    initializer 'solidus_importer.environment', before: :load_config_initializers do |_app|
      SolidusImporter::Config = SolidusImporter::Configuration.new
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework(:rspec)
    end
  end
end
