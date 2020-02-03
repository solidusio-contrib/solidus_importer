# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::VariantImages do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    context 'without an image src in row data' do
      let(:context) { { data: 'Some data', variant: nil } }

      it { is_expected.to eq(context) }
    end

    context 'without a variant in row data' do
      let(:context) { { data: data, variant: nil } }
      let(:data) { { 'Variant Image' => solidus_importer_fixture_path('thinking-cat.jpg') } }
      let(:result_error) { context.merge(success: false, messages: 'Missing required target variant') }

      it { is_expected.to eq(result_error) }
    end

    context 'with a variant and a invalid image in row data' do
      let(:context) { { data: data, variant: build_stubbed(:variant) } }
      let(:data) { { 'Variant Image' => 'some missing image' } }

      it 'returns an error context' do
        expect { described_method }.not_to change(context[:variant].images, :any?)
        expect(described_method[:success]).to be_falsey
        expect(described_method[:messages]).to include('No such file or directory')
      end
    end

    context 'with a variant and a valid image in row data' do
      let(:context) { { data: data, variant: build_stubbed(:variant) } }
      let(:data) { { 'Variant Image' => solidus_importer_fixture_path('thinking-cat.jpg') } }
      let(:result_success) { context.merge(success: true) }

      it 'add an image to the variant and returns an success context' do
        expect { described_method }.to change(context[:variant].images, :any?).from(false).to(true)
        expect(described_method).to eq(result_success)
      end
    end
  end
end
