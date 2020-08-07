# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::BaseImporter do
  subject(:described_instance) { described_class.new(options) }

  let(:options) { {} }

  describe '#after_import without order' do
    subject(:described_method) { described_instance.after_import(context) }

    let(:context) { {} }
    let(:post_processor) { spy }

    it 'execute post_processors' do
      expect(described_instance).to receive(:post_processors).and_return([post_processor])
      described_method
      expect(post_processor).to have_received(:call).with(context)
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
