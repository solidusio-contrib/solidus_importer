# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Variant do
  subject(:described_instance) { described_class.new(importer, row) }

  let(:importer) { SolidusImporter::Importers::Products }
  let(:row) {}

  describe '#call' do
    subject(:described_method) { described_instance.call(context) }

    let(:context) {}

    context 'with a not product row' do
      let(:row) { instance_double('SomeClass', data: { 'Variant SKU' => 'Some SKU' }) }
      let(:result_error) { { success: false, messages: 'Invalid row type' } }

      it 'returns an error context' do
        expect(described_method).to eq(result_error)
      end
    end

    context 'without a product' do
      let(:row) { build(:solidus_importer_row_variant, :with_import) }
      let(:result_error) { { success: false, messages: 'Product not found' } }

      it 'returns an error context' do
        expect(described_method).to eq(result_error)
      end
    end

    context 'with a variant row, a product and a source file' do
      let(:context) { { product: product } }
      let(:row) { build(:solidus_importer_row_variant, :with_import) }
      let(:variant) { Spree::Variant.last }
      let(:result) { { class_name: 'Spree::Variant', id: variant.id, new_record: true, success: true } }
      let(:product) { build_stubbed(:product, slug: 'a-product-slug-2') }
      let(:shipping_category) { create(:shipping_category) }

      before do
        allow(product).to receive(:touch)
        allow(Spree::Product).to receive(:find_by).and_return(product)
        allow(Spree::ShippingCategory).to receive(:last).and_return(build_stubbed(:shipping_category))
      end

      it 'creates a new variant' do
        expect { described_method }.to change { Spree::Variant.count }.by(1)
        expect(described_method).to eq(result)
        variant.destroy
      end

      context 'with an existing variant' do
        let(:yesterday) { 1.day.ago }
        let(:variant) { create(:variant, weight: 10.0, created_at: yesterday, updated_at: yesterday) }
        let(:result) { { class_name: 'Spree::Variant', id: variant.id, new_record: false, success: true } }

        before do
          variant
          allow(Spree::Variant).to receive(:find_or_initialize_by).and_return(variant)
        end

        after { variant.destroy }

        it 'updates the variant' do
          expect { described_method }.not_to(change { Spree::Variant.count })
          expect(described_method).to eq(result)
          expect(variant.reload.weight.to_f).to eq(20.0)
        end

        context 'with an invalid variant' do
          before { variant.product_id = nil }

          it "doesn't update the variant" do
            expect { described_method }.not_to(change { Spree::Variant.count })
            expect(described_method[:success]).to be_falsey
            expect(described_method[:messages]).not_to be_empty
          end
        end

        context 'with extra keys in data' do
          let(:result) { { success: false, messages: 'Invalid keys in row data' } }

          before { row.data['Some key'] = 'Some value' }

          it 'returns an error context with the error messages' do
            expect { described_method }.to change { Spree::Variant.count }.by(0)
            expect(described_method).to include(result)
          end
        end
      end
    end
  end
end
