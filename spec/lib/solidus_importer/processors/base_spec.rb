# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Base do
  subject(:described_instance) { described_class.new }

  it { expect(described_instance.options).to eq({}) }
end
