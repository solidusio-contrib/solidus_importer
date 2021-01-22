# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::BaseImporter do
  subject(:described_instance) { described_class.new(options) }

  let(:options) { {} }

  describe '#after_import' do
    it { is_expected.to respond_to(:after_import) }

    context 'when ending contexts of rows is a success' do
      subject { described_instance.after_import(context) }

      let(:context) { { success: true } }

      it 'returns a successful context' do
        expect(subject).to match(hash_including(success: true))
      end
    end
  end

  describe '#before_import' do
    it { is_expected.to respond_to(:before_import) }
  end

  describe '#processors' do
    subject(:described_method) { described_instance.processors }

    it { is_expected.to be_empty }
  end
end
