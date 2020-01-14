# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Order do
  subject(:described_instance) { described_class.new(importer, row) }

  let(:importer) { SolidusImporter::Importers::Orders }
  let(:row) {}

  describe '#call' do
    subject(:described_method) { described_instance.call(context) }

    let(:context) { {} }

    context 'with a not order row' do
      let(:row) { instance_double('SomeClass') }
      let(:result_error) { { success: false, messages: 'Invalid row type' } }

      it 'returns an error context' do
        expect(described_method).to eq(result_error)
      end
    end

    context 'with an order row with a file entity' do
      let(:row) { build(:solidus_importer_row_order, :with_import) }
      let(:order) { Spree::Order.last }
      let(:result) { { class_name: 'Spree::Order', id: order.id, new_record: true, success: true } }

      before { allow(Spree::Store).to receive(:default).and_return(build_stubbed(:store)) }

      it 'creates a new order' do
        expect { described_method }.to change { Spree::Order.count }.by(1)
        expect(described_method).to eq(result)
        order.destroy
      end

      context 'with an existing order' do
        let(:yesterday) { 1.day.ago }
        let(:order) { create(:order, email: 'test@example.com', created_at: yesterday, updated_at: yesterday) }
        let(:result) { { class_name: 'Spree::Order', id: order.id, new_record: false, success: true } }

        before do
          order
          allow(Spree::Order).to receive(:find_or_initialize_by).and_return(order)
        end

        after { order.destroy }

        it 'updates the order' do
          expect { described_method }.not_to(change{ Spree::Order.count })
          expect(described_method).to eq(result)
          expect(order.reload.email).to eq('an_email@example.com')
        end

        context 'with an invalid order' do
          let(:order) do
            create(:order, email: 'test@example.com', created_at: yesterday, updated_at: yesterday).tap do |ord|
              ord.state = 'an invalid state'
            end
          end

          it { expect(described_method[:success]).to be_falsey }
        end
      end

      context 'with an invalid attribute in mapping' do
        before { allow(described_instance).to receive(:mapping).and_return('Name' => :invalid_attr) }

        it "doesn't update the order" do
          expect { described_method }.not_to(change { Spree::Order.count })
          expect(described_method[:success]).to be_falsey
          expect(described_method[:messages]).not_to be_empty
        end
      end
    end

    context 'with extra keys in data' do
      let(:row) { build(:solidus_importer_row_order, :with_import, data: data) }
      let(:data) { { store_id: 0 } }
      let(:result) { { success: false, messages: 'Invalid keys in row data' } }

      it 'returns an error context with the error messages' do
        expect { described_method }.to change { Spree::Order.count }.by(0)
        expect(described_method).to include(result)
      end
    end
  end
end
