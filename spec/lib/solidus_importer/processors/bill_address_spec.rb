# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::BillAddress do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) do
      { data: data }
    end
    let(:data) do
      {
        'Billing First Name' => 'John',
        'Billing Last Name' => 'Doe',
        'Billing Address1' => 'An address',
        'Billing Address2' => '',
        'Billing City' => 'A Beautyful city',
        'Billing Company' => 'A Company',
        'Billing Zip' => '00000',
        'Billing Phone' => '555-123123123',
        'Billing Country Code' => 'US',
        'Billing Province Code' => 'NM'
      }
    end

    it 'put bill_address_attributes into order data' do
      described_method
      expect(context).to have_key(:order)
      expect(context[:order][:bill_address_attributes]).not_to be_empty
    end
  end
end
