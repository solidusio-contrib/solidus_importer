# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Log do
  subject(:described_instance) { described_class.new(importer, row) }

  let(:importer) { class_double('AnImporter') }
  let(:row) { instance_double(SolidusImporter::Row) }

  describe '#call' do
    subject(:described_method) { described_instance.call(context) }

    let(:context) { {} }

    before { allow(Spree::LogEntry).to receive(:create!) }

    it 'creates a log entry' do
      described_method
      expect(Spree::LogEntry).to have_received(:create!)
    end
  end

  describe '#ensure_call' do
    subject(:described_method) { described_instance.ensure_call }

    it { is_expected.to be_truthy }
  end
end
