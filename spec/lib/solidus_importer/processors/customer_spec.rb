# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Customer do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { {} }

    context 'without customer email in row data' do
      let(:context) do
        { data: 'Some data' }
      end

      it 'raises an exception' do
        expect { described_method }.to raise_error(SolidusImporter::Exception, 'Missing required key: "Email"')
      end
    end

    context 'with invalid fields in row data' do
      let(:context) do
        { data: { 'Email' => '-' } }
      end

      it 'raises an exception' do
        expect { described_method }.to raise_error(ActiveRecord::RecordInvalid, /Email is invalid/)
      end
    end

    context 'with a customer row with a file entity' do
      let(:context) do
        { data: build(:solidus_importer_row_customer, :with_import).data.merge(customer_address_data) }
      end
      let(:customer_address_data) do
        {
          'First Name' => 'John',
          'Last Name' => 'Doe',
          'Address1' => 'My Cool Address, n.1',
          'Address2' => '',
          'City' => 'My beautiful City',
          'Zip' => '12345',
          'Phone' => '(555)-123123123',
          'Country Code' => 'US',
          'Province Code' => 'WA'
        }
      end
      let(:result) { context.merge(user: Spree::User.last) }

      it 'creates a new user' do
        expect { described_method }.to change(Spree::User, :count).by(1)
        expect(described_method).to eq(result)
      end

      context 'with an existing valid user' do
        let!(:user) { create(:user) }
        let(:result) { context.merge(user: user) }

        before { allow(Spree::User).to receive(:find_or_initialize_by).and_return(user) }

        it 'updates the user' do
          expect { described_method }.not_to(change(Spree::User, :count))
          expect(described_method).to eq(result)
        end
      end

      context 'with an existing invalid user' do
        let!(:user) { create(:user).tap { |user| user.password = nil } }

        before { allow(Spree::User).to receive(:find_or_initialize_by).and_return(user) }

        it 'raises an exception' do
          expect { described_method }.to raise_error(ActiveRecord::RecordInvalid, /Password can't be blank/)
        end
      end
    end
  end
end
