# frozen_string_literal: true

module SolidusImporterHelpers
  def solidus_importer_fixture_path(fixture)
    File.join(__dir__, '../fixtures/solidus_importer', fixture)
  end
end

RSpec.configure do |config|
  config.include SolidusImporterHelpers
end

FactoryBot::SyntaxRunner.include SolidusImporterHelpers
