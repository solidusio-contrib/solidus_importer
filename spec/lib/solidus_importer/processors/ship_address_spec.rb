# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::ShipAddress do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) do
      { data: data }
    end
    let(:data) do
      {
        'Shipping First Name' => 'John',
        'Shipping Last Name' => 'Doe',
        'Shipping Address1' => 'An address',
        'Shipping Address2' => '',
        'Shipping City' => 'A Beautyful city',
        'Shipping Company' => 'A Company',
        'Shipping Zip' => '00000',
        'Shipping Phone' => '555-123123123',
        'Shipping Country Code' => 'US',
        'Shipping Province Code' => 'NM'
      }
    end

    it 'put ship_address_attributes into order data' do
      described_method
      expect(context).to have_key(:order)
      expect(context[:order][:ship_address_attributes]).not_to be_empty
    end
  end
end
