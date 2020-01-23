# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::ProductImages do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    context 'without an image src in row data' do
      let(:context) { { data: 'Some data', entity: nil } }

      it { is_expected.to eq(context) }
    end

    context 'without a product in row data' do
      let(:context) { { data: data, entity: nil } }
      let(:data) { { 'Image Src' => solidus_importer_fixture_path('thinking-cat.jpg') } }
      let(:result_error) { context.merge(success: false, messages: 'Target entity must be a valid product') }

      it { is_expected.to eq(result_error) }
    end

    context 'without a valid product in row data' do
      let(:context) { { data: data, entity: build_stubbed(:variant) } }
      let(:data) { { 'Image Src' => solidus_importer_fixture_path('thinking-cat.jpg') } }
      let(:result_error) { context.merge(success: false, messages: 'Target entity must be a valid product') }

      it { is_expected.to eq(result_error) }
    end

    context 'with a product and a invalid image in row data' do
      let(:context) { { data: data, entity: build_stubbed(:product) } }
      let(:data) { { 'Image Src' => 'some missing image' } }
      let(:result_error) { context.merge(success: false, messages: 'Target entity must be a valid product') }

      it 'returns an error context' do
        expect { described_method }.not_to change(context[:entity].images, :any?)
        expect(described_method[:success]).to be_falsey
        expect(described_method[:messages]).to include('No such file or directory')
      end
    end

    context 'with a product and a valid image in row data' do
      let(:context) { { data: data, entity: build_stubbed(:product) } }
      let(:data) { { 'Image Src' => solidus_importer_fixture_path('thinking-cat.jpg') } }
      let(:result_success) { context.merge(success: true) }

      it 'add an image to the product and returns an success context' do
        expect { described_method }.to change(context[:entity].images, :any?).from(false).to(true)
        expect(described_method).to eq(result_success)
      end
    end
  end
end
