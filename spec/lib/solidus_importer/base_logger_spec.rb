# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::BaseLogger do
  subject(:described_instance) { described_class.new }

  let(:logger) { instance_double('Logger', described_method => true) }

  before { allow(Logger).to receive(:new).and_return(logger) }

  describe '#debug' do
    let(:described_method) { :debug }

    before { logger.public_send(described_method, 'Test') }

    it { expect(logger).to have_received(described_method) }
  end

  describe '#error' do
    let(:described_method) { :error }

    before { logger.public_send(described_method, 'Test') }

    it { expect(logger).to have_received(described_method) }
  end

  describe '#fatal' do
    let(:described_method) { :fatal }

    before { logger.public_send(described_method, 'Test') }

    it { expect(logger).to have_received(described_method) }
  end

  describe '#info' do
    let(:described_method) { :info }

    before { logger.public_send(described_method, 'Test') }

    it { expect(logger).to have_received(described_method) }
  end

  describe '#unknown' do
    let(:described_method) { :unknown }

    before { logger.public_send(described_method, 'Test') }

    it { expect(logger).to have_received(described_method) }
  end

  describe '#warn' do
    let(:described_method) { :warn }

    before { logger.public_send(described_method, 'Test') }

    it { expect(logger).to have_received(described_method) }
  end
end
