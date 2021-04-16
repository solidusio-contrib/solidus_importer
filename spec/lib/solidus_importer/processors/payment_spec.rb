# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Payment do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) do
      { data: data }
    end
    let(:data) do
      {
        'Financial Status' => 'paid',
        'Lineitem price' => '10.5',
        'Lineitem quantity' => '2'
      }
    end
    let(:expected_params) do
      { payment_method: payment_method_name, amount: amount }
    end
    let(:payment_method_name) { 'SolidusImporter PaymentMethod' }
    let(:amount) { 21.0 }

    it 'put payments_attributes into order data' do
      described_method
      expect(context).to have_key(:order)
      expect(context[:order][:payments_attributes]).to eq expected_params
    end
  end
end
