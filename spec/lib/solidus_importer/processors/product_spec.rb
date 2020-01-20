# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Product do
  subject(:described_instance) { described_class.new(importer, row) }

  let(:importer) { SolidusImporter::Importers::Products }
  let(:row) {}

  describe '#call' do
    subject(:described_method) { described_instance.call({}) }

    context 'with a not product row' do
      let(:row) { instance_double('SomeClass') }
      let(:result_error) { { success: false, messages: 'Invalid row type' } }

      it 'returns an error context' do
        expect(described_method).to eq(result_error)
      end
    end

    context 'with a product row with a file entity' do
      let(:row) { build(:solidus_importer_row_product, :with_import) }
      let(:product) { Spree::Product.last }
      let(:result) { { class_name: 'Spree::Product', id: product.id, new_record: true, success: true } }
      let(:shipping_category) { create(:shipping_category) }

      before { shipping_category }

      after { shipping_category.destroy }

      it 'creates a new product' do
        expect { described_method }.to change { Spree::Product.count }.by(1)
        expect(described_method).to eq(result)
        product.destroy
      end

      context 'with an existing product' do
        let(:yesterday) { 1.day.ago }
        let(:product) { create(:product, name: 'Some product', created_at: yesterday, updated_at: yesterday) }
        let(:result) { { class_name: 'Spree::Product', id: product.id, new_record: false, success: true } }

        before do
          product
          allow(Spree::Product).to receive(:find_by).and_return(product)
        end

        after { product.destroy }

        it 'updates the product' do
          expect { described_method }.not_to(change { Spree::Product.count })
          expect(described_method).to eq(result)
          expect(product.reload.name).to eq('A product name')
        end

        context 'with an invalid product' do
          before do
            product.name = ''
            row.data['Title'] = nil
          end

          it "doesn't update the product" do
            expect { described_method }.not_to(change { Spree::Product.count })
            expect(described_method[:success]).to be_falsey
            expect(described_method[:messages]).not_to be_empty
          end
        end

        context 'with an invalid attribute' do
          before { allow(described_instance).to receive(:mapping).and_return('Handle' => :slug, 'Title' => :invalid_attr) }

          it "doesn't update the product" do
            expect { described_method }.not_to(change { Spree::Product.count })
            expect(described_method[:success]).to be_falsey
            expect(described_method[:messages]).not_to be_empty
          end
        end

        context 'with extra keys in data' do
          let(:result) { { success: false, messages: 'Invalid keys in row data' } }

          before { row.data['Some key'] = 'Some value' }

          it 'returns an error context with the error messages' do
            expect { described_method }.to change { Spree::Order.count }.by(0)
            expect(described_method).to include(result)
          end
        end
      end
    end
  end
end
