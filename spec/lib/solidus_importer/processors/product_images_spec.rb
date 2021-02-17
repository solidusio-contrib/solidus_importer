# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::ProductImages do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    context 'without "Image Src" attribute in row data' do
      let(:context) do
        { data: { 'Some attr' => 'some value' }, product: build_stubbed(:product) }
      end

      it 'returns nothing' do
        expect(described_method).to be_nil
      end
    end

    context 'with a product and a invalid image in row data' do
      let(:context) do
        { data: { 'Image Src' => 'some missing image' }, product: build_stubbed(:product) }
      end

      it 'raises an exception' do
        expect { described_method }.to raise_error(URI::InvalidURIError, /bad URI/)
      end
    end

    context 'with a product and a valid image in row data' do
      let(:context) do
        { data: { 'Image Src' => 'http://remote-service.net/thinking-cat.jpg' }, product: build_stubbed(:product) }
      end
      let(:uri) { instance_double(URI::HTTP, open: File.open(solidus_importer_fixture_path('thinking-cat.jpg'))) }

      before do
        allow(URI).to receive(:parse).and_return(uri)
      end

      it 'adds images to the product' do
        expect { described_method }.to change(context[:product].images, :any?).from(false).to(true)
      end
    end
  end
end
