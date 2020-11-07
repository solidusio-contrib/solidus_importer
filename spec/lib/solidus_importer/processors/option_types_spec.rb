# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::OptionTypes do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { { data: data, product: product } }
    let(:product) { create :base_product }
    let(:color) { create :option_type, presentation: 'The color', name: 'color' }
    let(:size) { create :option_type, presentation: 'The size', name: 'size' }
    let(:data) do
      {
        'Option1 Name' => 'Size',
        'Option2 Name' => 'Color'
      }
    end

    context 'when "Option(1,2,3) Name" are present' do
      context 'when product does not have option types' do
        before do
          color
          size
        end

        xit 'does not create option type records' do
          expect { described_method }.not_to change(Spree::OptionType, :count)
        end
      end

      context 'when product already has option types' do
        before { product.option_types << color << size }

        it 'do not create other option types' do
          expect { described_method }.not_to change(product.option_types, :count)
        end
      end

      it 'create option types for product in row' do
        expect { described_method }.to change(product.option_types, :count).from(0).to(2)
        expect(product.option_types.first.presentation).to eq 'Size'
        expect(product.option_types.first.name).to eq 'size'
        expect(product.option_types.last.presentation).to eq 'Color'
        expect(product.option_types.last.name).to eq 'color'
      end
    end
  end
end
