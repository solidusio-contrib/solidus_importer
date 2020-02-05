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
        if Spree.solidus_gem_version < Gem::Version.new('2.8')
          expect { described_method }.to raise_error(RuntimeError, /No master variant found/)
        else
          expect { described_method }.to raise_error(ActiveRecord::RecordInvalid, /Product must exist/)
        end
      end
    end

    context 'with a variant row, a product and a source file' do
      let(:context) do
        { data: data, product: product }
      end
      let(:data) { build(:solidus_importer_row_variant, :with_import).data }
      let(:product) { build_stubbed(:product, slug: data['Handle']) }
      let(:result) { context.merge(variant: Spree::Variant.last) }

      before do
        allow(product).to receive(:touch)
        allow(Spree::ShippingCategory).to receive(:last).and_return(build_stubbed(:shipping_category))
      end

      it 'creates a new variant' do
        expect { described_method }.to change { Spree::Variant.count }.by(1)
        expect(described_method).to eq(result)
      end

      context 'with an existing valid variant' do
        let!(:variant) { create(:variant, sku: data['Variant SKU'], weight: 10.0) }

        it 'updates the variant' do
          expect { described_method }.not_to(change { Spree::Variant.count })
          expect(described_method).to eq(result)
          expect(variant.reload.weight.to_f).to eq(data['Variant Weight'])
        end
      end

      context 'with an existing invalid variant' do
        let!(:variant) do
          create(:variant, sku: data['Variant SKU'], weight: 10.0).tap do |variant|
            variant.update_column(:product_id, nil)
          end
        end

        it 'raises an exception' do
          expect { described_method }.to raise_error(ActiveRecord::RecordInvalid, /Product must exist/)
        end
      end
    end
  end
end
