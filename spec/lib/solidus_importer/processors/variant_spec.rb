# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Variant do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    context 'without a target product' do
      let(:context) do
        { data: { 'Variant SKU' => 'some SKU' }, product: nil }
      end

      it 'raises an exception' do
        expect { described_method }.to raise_error(ArgumentError, 'missing :product in context')
      end
    end

    context 'with a variant row, a product and a source file' do
      let(:context) do
        { data: data, product: product }
      end
      let(:data) { build(:solidus_importer_row_variant, :with_import).data }
      let!(:product) { create(:product, slug: data['Handle']) }

      before do
        allow(Spree::ShippingCategory).to receive(:last).and_return(build_stubbed(:shipping_category))
      end

      context 'when "Option1 Value" is "Some value"' do
        let(:result) { context.merge(variant: product.variants.first) }

        before { data.merge! 'Option1 Value' => 'Some value' }

        it 'creates a new variant' do
          expect { described_method }.to change { Spree::Variant.count }.by(1)
          expect(described_method).to eq(result)
          expect(product.variants.first.weight).to eq 20.0
          expect(product.variants.first.price).to eq 60.5
          expect(product.variants.first.total_on_hand).to eq 5
        end
      end

      context 'when "Option1 Value" is "Default Title"' do
        let(:result) { context.merge(variant: product.master) }

        before { data.merge! 'Option1 Value' => 'Default Title' }

        it 'updates master variant' do
          expect { described_method }.not_to(change { Spree::Variant.count })
          expect(described_method).to eq(result)
          expect(product.master.weight).to eq 20.0
          expect(product.master.price).to eq 60.5
        end
      end

      context 'when "Option1 Value" is blank' do
        let(:result) { context.merge(variant: product.master) }

        before { data.merge! 'Option1 Value' => nil }

        it 'updates master variant' do
          expect { described_method }.not_to(change { Spree::Variant.count })
          expect(described_method).to eq(result)
          expect(product.master.weight).to eq 20.0
          expect(product.master.price).to eq 60.5
        end
      end

      context 'with an existing valid variant' do
        let(:result) { context.merge(variant: variant) }
        let!(:variant) { create(:variant, sku: data['Variant SKU'], price: 0, weight: 10.0) }

        before { data.merge! 'Option1 Value' => 'Some value' }

        it 'updates the variant' do
          expect { described_method }.not_to(change { Spree::Variant.count })
          expect(described_method).to eq(result)
          expect(variant.reload.weight.to_f).to eq(data['Variant Weight'])
          expect(variant.reload.price).to eq(data['Variant Price'])
        end
      end
    end
  end
end
