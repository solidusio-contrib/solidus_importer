# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Shipment do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) do
      { data: data }
    end
    let(:data) do
      { 'Shipping Line Title' => 'ACME Shipping' }
    end

    it 'put shipments_attributes into order data' do
      described_method
      expect(context).to have_key(:order)
      expect(context[:order][:shipments_attributes]).not_to be_empty
    end
  end
end
