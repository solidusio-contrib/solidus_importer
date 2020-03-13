# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Log do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    before { allow(Spree::LogEntry).to receive(:create!) }

    it 'creates a log entry' do
      described_method
      expect(Spree::LogEntry).to have_received(:create!)
    end
  end
end
