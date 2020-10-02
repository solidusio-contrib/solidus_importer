# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::LineItem do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) do
      { data: data }
    end
    let(:data) do
      { 'Lineitem sku' => 'a-sku' }
    end

    it 'put line_items_attributes into order data' do
      described_method
      expect(context).to have_key(:order)
      expect(context[:order][:line_items_attributes]).not_to be_empty
    end
  end
end
