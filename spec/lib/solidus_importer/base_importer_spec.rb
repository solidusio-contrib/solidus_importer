# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::BaseImporter do
  subject(:described_instance) { described_class.new(options) }

  let(:options) { {} }

  context 'with some options' do
    let(:logger) { Logger.new(STDOUT) }
    let(:options) { { logger: logger } }

    it { expect(described_instance.logger).to eq logger }
  end

  describe '#after_import' do
    it { is_expected.to respond_to(:after_import) }
  end

  describe '#before_import' do
    it { is_expected.to respond_to(:before_import) }
  end

  describe '#process_row_failure' do
    it { is_expected.to respond_to(:process_row_failure) }
  end

  describe '#processors' do
    subject(:described_method) { described_instance.processors }

    it { is_expected.to be_empty }
  end
end
