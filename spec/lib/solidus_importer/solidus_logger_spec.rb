# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::SolidusLogger do
  subject(:described_instance) { described_class.new }

  let(:log) { instance_double(SolidusImporter::Log, source: true, context: {}) }

  before { allow(Spree::LogEntry).to receive(:create!) }

  describe '#debug' do
    let(:described_method) { :debug }

    before { described_instance.public_send(described_method, log) }

    it { expect(Spree::LogEntry).to have_received(:create!) }
  end

  describe '#error' do
    let(:described_method) { :error }

    before { described_instance.public_send(described_method, log) }

    it { expect(Spree::LogEntry).to have_received(:create!) }
  end

  describe '#fatal' do
    let(:described_method) { :fatal }

    before { described_instance.public_send(described_method, log) }

    it { expect(Spree::LogEntry).to have_received(:create!) }
  end

  describe '#info' do
    let(:described_method) { :info }

    before { described_instance.public_send(described_method, log) }

    it { expect(Spree::LogEntry).to have_received(:create!) }
  end

  describe '#unknown' do
    let(:described_method) { :unknown }

    before { described_instance.public_send(described_method, log) }

    it { expect(Spree::LogEntry).to have_received(:create!) }
  end

  describe '#warn' do
    let(:described_method) { :warn }

    before { described_instance.public_send(described_method, log) }

    it { expect(Spree::LogEntry).to have_received(:create!) }
  end
end
