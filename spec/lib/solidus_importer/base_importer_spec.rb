# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::BaseImporter do
  subject(:described_instance) { described_class.new(options) }

  let(:options) { {} }

  describe '#after_import' do
    it { is_expected.to respond_to(:after_import) }
  end

  describe '#before_import' do
    it { is_expected.to respond_to(:before_import) }
  end

  describe '#processors' do
    subject(:described_method) { described_instance.processors }

    it { is_expected.to be_empty }
  end
end
