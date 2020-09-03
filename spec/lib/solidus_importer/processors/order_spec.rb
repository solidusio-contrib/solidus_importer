# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Order do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    context 'without order number in row data' do
      let(:context) do
        { data: 'Some data' }
      end

      it 'raises an exception' do
        expect { described_method }.to raise_error(SolidusImporter::Exception, 'Missing required key: "Name"')
      end
    end

    context 'with an order row with a file entity' do
      let(:context) do
        { data: data }
      end
      let(:data) { build(:solidus_importer_row_order, :with_import).data }

      before { allow(Spree::Store).to receive(:default).and_return(build_stubbed(:store)) }

      it 'creates a new order' do
        expect { described_method }.to change { Spree::Order.count }.by(1)
        expect(context).to have_key(:order)
      end

      context 'with an existing valid order' do
        let!(:order) { create(:order, number: data['Name'], email: data['Email']) }

        it 'updates the order' do
          expect { described_method }.not_to(change{ Spree::Order.count })
          expect(context).to have_key(:order)
          expect(order.reload.email).to eq('an_email@example.com')
        end
      end

      context 'with an existing invalid order' do
        let!(:order) { create(:order, number: data['Name'], email: data['Email']) }

        before { order.update_column(:state, 'an invalid state') }

        it 'raises an exception' do
          expect { described_method }.to raise_error(ActiveRecord::RecordInvalid, /State is invalid/)
        end
      end
    end
  end
end
