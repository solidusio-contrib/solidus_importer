# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Customer do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    context 'without customer row data' do
      let(:result_error) { { success: false, messages: 'Missing input data' } }

      it 'returns an error context' do
        expect(described_method).to eq(result_error)
      end
    end

    context 'without customer email in row data' do
      let(:context) { { data: data } }
      let(:data) { 'Some data' }
      let(:result_error) { { data: data, success: false, messages: 'Missing required key: "Email Address"' } }

      it 'returns an error context' do
        expect(described_method).to eq(result_error)
      end
    end

    context 'with a customer row with a file entity' do
      let(:context) { { data: data } }
      let(:data) { build(:solidus_importer_row_customer, :with_import).data }
      let(:user) { Spree::User.last }
      let(:result) do
        { data: data, class_name: 'Spree::User', id: user.id, entity: user, new_record: true, success: true }
      end

      it 'creates a new user' do
        expect { described_method }.to change { Spree::User.count }.by(1)
        expect(described_method).to eq(result)
        user.destroy
      end

      context 'with an existing user' do
        let(:yesterday) { 1.day.ago }
        let(:user) { create(:user, created_at: yesterday, updated_at: yesterday) }
        let(:result) do
          { data: data, class_name: 'Spree::User', id: user.id, entity: user, new_record: false, success: true }
        end

        before do
          user
          allow(Spree::User).to receive(:find_or_initialize_by).and_return(user)
        end

        after { user.destroy }

        it 'updates the user' do
          expect { described_method }.not_to(change { Spree::User.count })
          expect(described_method).to eq(result)
        end

        context 'with an invalid user' do
          before { user.password = nil }

          it "doesn't update the user" do
            expect { described_method }.not_to(change { Spree::User.count })
            expect(described_method[:success]).to be_falsey
            expect(described_method[:messages]).not_to be_empty
          end
        end
      end
    end

    context 'with invalid data' do
      let(:data) { { 'Email Address' => '-' } }
      let(:context) { { data: data } }
      let(:result) { { data: data, success: false, messages: 'Email is invalid' } }

      it 'returns an error context with the error messages' do
        expect { described_method }.to change { Spree::User.count }.by(0)
        expect(described_method).to include(result)
      end
    end
  end
end