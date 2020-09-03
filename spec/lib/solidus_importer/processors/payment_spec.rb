# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Payment do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    context 'without a target order' do
      let(:context) do
        { data: {}, order: nil }
      end

      it 'creates the meta-model for Spree::Payment' do
        expect { described_method }.to raise_error(SolidusImporter::Exception, 'no :order given')
      end
    end

    shared_examples 'creates a payment for the order' do |amount:|
      it 'creates the a Spree::Payment for the order' do
        expect { described_method }.to change(Spree::Payment, :count).by(1)
        expect(payment.order).to eq order
        expect(payment.amount).to eq amount
      end
    end

    context 'when "Transaction Status" is "success"' do
      let(:context) do
        { data: data, order: order }
      end
      let(:order) { create(:order) }
      let(:data) do
        {
          'Transaction Status' => 'success',
          'Transaction Amount' => '10.3',
          'Transaction Kind' => 'sale'
        }
      end
      let(:payment) { Spree::Payment.first }

      include_examples 'creates a payment for the order', amount: 10.3

      context 'when "Transaction Status" is blank' do
        let(:data) do
          {
            'Transaction Status' => '',
            'Transaction Amount' => '10.3',
            'Transaction Kind' => 'sale'
          }
        end

        include_examples 'creates a payment for the order', amount: 10.3
      end

      context 'when "Transaction Kind" is "capture"' do
        let(:data) do
          {
            'Transaction Status' => '',
            'Transaction Amount' => '10.3',
            'Transaction Kind' => 'capture'
          }
        end

        include_examples 'creates a payment for the order', amount: 10.3
      end

      context 'when "Transaction Kind" is "sale"' do
        let(:data) do
          {
            'Transaction Status' => '',
            'Transaction Amount' => '10.3',
            'Transaction Kind' => 'sale'
          }
        end

        include_examples 'creates a payment for the order', amount: 10.3
      end

      context 'when "Transaction Amount" is blank' do
        let(:data) do
          {
            'Transaction Status' => '',
            'Transaction Amount' => '',
            'Transaction Kind' => 'sale'
          }
        end

        it 'does not create any payment' do
          expect { described_method }.not_to change(Spree::Payment, :count)
        end
      end
    end
  end
end
