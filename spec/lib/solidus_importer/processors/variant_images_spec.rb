# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::VariantImages do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    context 'without "Variant Image" attribute in row data' do
      let(:context) do
        { data: { 'Some attr' => 'some value' }, product: build_stubbed(:product) }
      end

      it 'returns nothing' do
        expect(described_method).to be_nil
      end
    end

    context 'with a variant and a invalid image in row data' do
      let(:context) do
        { data: { 'Variant Image' => 'some missing image' }, variant: build_stubbed(:variant) }
      end

      it 'raises an exception' do
        expect { described_method }.to raise_error(URI::InvalidURIError, /bad URI/)
      end
    end

    context 'with a variant and a valid image in row data' do
      let(:context) do
        {
          data: { 'Variant Image' => 'http://remote-service.net/thinking-cat.jpg' },
          variant: build(:variant)
        }
      end
      let(:uri) do
        instance_double(
          URI::HTTP,
          path: 'thinking-cat.jpg',
          open: File.open(solidus_importer_fixture_path('thinking-cat.jpg'))
        )
      end

      before do
        allow(URI).to receive(:parse).and_return(uri)
      end

      it 'adds images to the variant' do
        expect { described_method }.to change(context[:variant].images, :any?).from(false).to(true)
      end
    end
  end
end
