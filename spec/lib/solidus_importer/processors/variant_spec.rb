# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Variant do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    context 'without variant row data' do
      let(:result_error) { { success: false, messages: 'Missing input data' } }

      it 'returns an error context' do
        expect(described_method).to eq(result_error)
      end
    end

    context 'without variant SKU in row data' do
      let(:data) { 'some data' }
      let(:context) { { data: data } }
      let(:result) { { data: data } }

      it 'skips the processor execution' do
        expect(described_method).to eq(result)
      end
    end

    context 'without a target product' do
      let(:data) { { 'Variant SKU' => 'some SKU' } }
      let(:context) { { data: data } }
      let(:result_error) { { data: data, success: false, messages: 'Missing product' } }

      it 'returns an error context' do
        expect(described_method).to eq(result_error)
      end
    end

    context 'with a variant row, a product and a source file' do
      let(:context) { { data: data, product: product } }
      let(:data) { build(:solidus_importer_row_variant, :with_import).data }
      let(:variant) { Spree::Variant.last }
      let(:result) do
        {
          data: data,
          product: product,
          class_name: 'Spree::Variant',
          id: variant.id,
          entity: variant,
          new_record: true,
          success: true
        }
      end
      let(:product) { build_stubbed(:product, slug: data['Handle']) }

      before do
        allow(product).to receive(:touch)
        allow(Spree::ShippingCategory).to receive(:last).and_return(build_stubbed(:shipping_category))
      end

      it 'creates a new variant' do
        expect { described_method }.to change { Spree::Variant.count }.by(1)
        expect(described_method).to eq(result)
        variant.destroy
      end

      context 'with an existing variant' do
        let(:variant) { create(:variant, sku: data['Variant SKU'], weight: 10.0) }

        before do
          result[:new_record] = false
          variant
        end

        after { variant.destroy }

        it 'updates the variant' do
          expect { described_method }.not_to(change { Spree::Variant.count })
          expect(described_method).to eq(result)
          expect(variant.reload.weight.to_f).to eq(data['Variant Weight'])
        end

        context 'with an invalid variant' do
          before { variant.update_column(:product_id, nil) }

          it "doesn't update the variant" do
            expect { described_method }.not_to(change { Spree::Variant.count })
            expect(described_method[:success]).to be_falsey
            expect(described_method[:messages]).not_to be_empty
          end
        end
      end
    end
  end
end
