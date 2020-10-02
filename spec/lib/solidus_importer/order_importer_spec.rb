# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::OrderImporter do
  subject(:described_instance) { described_class.new(options) }

  let(:options) { {} }

  describe '#after_import' do
    subject(:ending_context) { described_instance.after_import }

    context 'when there are orders attributes' do
      let(:orders) do
        {
          '#001' => {
            number: '#001',
            email: 'email@example.com'
          },
          '#002' => {
            number: '#002',
            email: 'email@example.com'
          }
        }
      end

      before do
        described_instance.orders = orders
        allow(Spree::Core::Importer::Order).to receive(:import)
      end

      it 'calls Solidus order importer with those params' do
        expect(ending_context).to be_an_instance_of(Hash)
        expect(Spree::Core::Importer::Order).to have_received(:import)
          .with(nil, hash_including(email: 'email@example.com'))
          .exactly(orders.size).times
      end
    end
  end

  describe '#before_import' do
    it { is_expected.to respond_to(:before_import) }
  end

  describe '#processors' do
    subject(:described_method) { described_instance.processors }

    it { is_expected.to be_empty }
  end
end
