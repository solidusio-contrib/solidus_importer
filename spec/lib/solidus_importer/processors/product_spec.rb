# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Product do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    context 'without product slug in row data' do
      let(:context) do
        { data: 'Some data' }
      end

      it 'raises an exception' do
        expect { described_method }.to raise_error(SolidusImporter::Exception, 'Missing required key: "Handle"')
      end
    end

    context 'with a product row with a file entity' do
      let(:context) do
        { data: data }
      end
      let(:data) { build(:solidus_importer_row_product, :with_import).data }
      let(:result) { context.merge(product: Spree::Product.last) }
      let!(:shipping_category) { create(:shipping_category) }

      it 'creates a new product' do
        expect { described_method }.to change { Spree::Product.count }.by(1)
        expect(described_method).to eq(result)
      end

      context 'with an existing valid product' do
        let(:result) { { data: data, product: product } }
        let!(:product) { create(:product, slug: data['Handle']) }

        it 'updates the product' do
          expect { described_method }.not_to(change { Spree::Product.count })
          expect(described_method).to eq(result)
          expect(product.reload.name).to eq('A product name')
        end
      end
    end
  end
end
