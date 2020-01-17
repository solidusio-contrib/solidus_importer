# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Product do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    context 'without product row data' do
      let(:result_error) { { success: false, messages: 'Missing input data' } }

      it 'returns an error context' do
        expect(described_method).to eq(result_error)
      end
    end

    context 'without product slug in row data' do
      let(:context) { { data: data } }
      let(:data) { 'Some data' }
      let(:result_error) { { data: data, success: false, messages: 'Missing required key: "Handle"' } }

      it 'returns an error context' do
        expect(described_method).to eq(result_error)
      end
    end

    context 'with a product row with a file entity' do
      let(:context) { { data: data } }
      let(:data) { build(:solidus_importer_row_product, :with_import).data }
      let(:product) { Spree::Product.last }
      let(:result) do
        { data: data, class_name: 'Spree::Product', id: product.id, entity: product, new_record: true, success: true }
      end
      let(:shipping_category) { create(:shipping_category) }

      before { shipping_category }

      after { shipping_category.destroy }

      it 'creates a new product' do
        expect { described_method }.to change { Spree::Product.count }.by(1)
        expect(described_method).to eq(result)
        product.destroy
      end

      context 'with an existing product' do
        let(:product) { create(:product, slug: data['Handle']) }
        let(:result) do
          {
            data: data,
            class_name: 'Spree::Product',
            id: product.id,
            entity: product,
            new_record: false,
            success: true
          }
        end

        before { product }

        after { product.destroy }

        it 'updates the product' do
          expect { described_method }.not_to(change { Spree::Product.count })
          expect(described_method).to eq(result)
          expect(product.reload.name).to eq('A product name')
        end

        context 'with an invalid product' do
          before do
            product.update_column(:name, '')
            data['Title'] = nil
          end

          it "doesn't update the product" do
            expect { described_method }.not_to(change { Spree::Product.count })
            expect(described_method[:success]).to be_falsey
            expect(described_method[:messages]).not_to be_empty
          end
        end
      end
    end
  end
end
