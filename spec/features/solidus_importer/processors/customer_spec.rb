# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Customer do
  subject(:described_instance) { described_class.new(importer, row) }

  let(:importer) { SolidusImporter::Importers::Customers }
  let(:row) {}

  describe '#call' do
    subject(:described_method) { described_instance.call(context) }

    let(:context) { {} }

    context 'with a not customer row' do
      let(:row) { instance_double('SomeClass') }
      let(:result_error) { { success: false, messages: 'Invalid row type' } }

      it 'returns an error context' do
        expect(described_method).to eq(result_error)
      end
    end

    context 'with a customer row with a file entity' do
      let(:row) { build(:solidus_importer_row_customer, :with_import) }
      let(:user) { Spree::User.last }
      let(:result) { { class_name: 'Spree::User', id: user.id, new_record: true, success: true } }

      it 'creates a new user' do
        expect { described_method }.to change { Spree::User.count }.by(1)
        expect(described_method).to eq(result)
        user.destroy
      end

      context 'with an existing user' do
        let(:yesterday) { 1.day.ago }
        let(:user) { create(:user, created_at: yesterday, updated_at: yesterday) }
        let(:result) { { class_name: 'Spree::User', id: user.id, new_record: false, success: true } }

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

      context 'with an invalid attribute in mapping' do
        before { allow(described_instance).to receive(:mapping).and_return('Email Address' => :invalid_attr) }

        it "doesn't update the user" do
          expect { described_method }.not_to(change { Spree::User.count })
          expect(described_method[:success]).to be_falsey
          expect(described_method[:messages]).not_to be_empty
        end
      end
    end

    context 'with invalid data' do
      let(:row) { build(:solidus_importer_row_customer, :with_import, data: data) }
      let(:data) { { 'Email Address' => '' } }
      let(:result) { { success: false, messages: "Email can't be blank" } }

      it 'returns an error context with the error messages' do
        expect { described_method }.to change { Spree::User.count }.by(0)
        expect(described_method).to include(result)
      end
    end

    context 'with extra keys in data' do
      let(:row) { build(:solidus_importer_row_customer, :with_import, data: data) }
      let(:data) { { 'Email Address' => 'something', 'A field' => 'A value' } }
      let(:result) { { success: false, messages: 'Invalid keys in row data' } }

      it 'returns an error context with the error messages' do
        expect { described_method }.to change { Spree::User.count }.by(0)
        expect(described_method).to include(result)
      end
    end
  end
end
