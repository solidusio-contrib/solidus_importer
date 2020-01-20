# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Base do
  subject(:described_instance) { described_class.new }

  it { expect(described_instance.options).to eq({}) }

  describe '.ensure_call' do
    subject(:described_method) { described_class.ensure_call }

    it { is_expected.to be_falsey }
  end
end
