# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::OptionValues do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { { data: data, variant: variant } }
    let(:variant) { create :base_variant }
    let(:product) { variant.product }
    let(:color) { create :option_type, presentation: 'Color' }
    let(:size) { create :option_type, presentation: 'Size', name: 'size' }
    let(:data) do
      {
        'Option1 Name' => 'Size',
        'Option1 Value' => 'L',
        'Option2 Name' => 'Color',
        'Option2 Value' => 'Black'
      }
    end

    before { product.option_types << size << color }

    context 'when "Option(1,2,3) Value" are present' do
      it 'create option values for variant in row' do
        expect { described_method }.to change(variant.option_values, :count).from(0).to(2)
        expect(variant.option_values.first.presentation).to eq 'L'
        expect(variant.option_values.first.name).to eq 'l'
        expect(variant.option_values.last.presentation).to eq 'Black'
        expect(variant.option_values.last.name).to eq 'black'
      end

      it 'creates "Black" option value for related "Color" option type' do
        described_method
        black = variant.option_values.find_by(presentation: 'Black')
        l = variant.option_values.find_by(presentation: 'L')
        expect(black.option_type).to eq color
        expect(l.option_type).to eq size
      end
    end

    context 'when an Option has an empty value' do
      let(:data) do
        {
          'Option1 Name' => 'Size',
          'Option1 Value' => ''
        }
      end

      it 'does not create option values for variant in row' do
        expect { described_method }.not_to change(variant.option_values, :count)
      end
    end

    context 'when an Option is imported a second time for the same variant' do
      let(:data) do
        {
          'Option1 Name' => 'Size',
          'Option1 Value' => '3XL'
        }
      end

      it 'is not added' do
        variant.set_option_value('size', '3xl')
        expect { described_method }.not_to change(variant.option_values, :count)
      end
    end
  end
end
