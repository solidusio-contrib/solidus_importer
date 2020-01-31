# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Order do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    context 'without order number in row data' do
      let(:context) { { data: data } }
      let(:data) { 'Some data' }
      let(:result_error) { { data: data, success: false, messages: 'Missing required key: "Name"' } }

      it 'returns an error context' do
        expect(described_method).to eq(result_error)
      end
    end

    context 'with an order row with a file entity' do
      let(:context) { { data: data } }
      let(:data) { build(:solidus_importer_row_order, :with_import).data }
      let(:order) { Spree::Order.last }
      let(:result) { { data: data, success: true, order: order, new_record: true, messages: '' } }

      before { allow(Spree::Store).to receive(:default).and_return(build_stubbed(:store)) }

      it 'creates a new order' do
        expect { described_method }.to change { Spree::Order.count }.by(1)
        expect(described_method).to eq(result)
      end

      context 'with an existing order' do
        let(:result) { { data: data, order: order, new_record: false, messages: '', success: true } }
        let!(:order) { create(:order, number: data['Name'], email: data['Email']) }

        it 'updates the order' do
          expect { described_method }.not_to(change{ Spree::Order.count })
          expect(described_method).to eq(result)
          expect(order.reload.email).to eq('an_email@example.com')
        end

        context 'with an invalid order' do
          before { order.update_column(:state, 'an invalid state') }

          it { expect(described_method[:success]).to be_falsey }
        end
      end
    end
  end
end
