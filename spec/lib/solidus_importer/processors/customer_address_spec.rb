# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::CustomerAddress do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { { data: data, user: user } }
    let(:user) { create(:user) }
    let!(:state) { create(:state, state_code: 'WA', country_iso: 'US') }
    let(:country) { state.country }
    let(:data) do
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
    let(:address) { Spree::Address.last }

    context 'when there is a state with the same code attached to another country' do
      let(:wrong_state) { create(:state, state_code: 'WA', country_iso: 'IT') }
      let(:state) { create(:state, state_code: 'XX', country_iso: 'US') }

      before { state and wrong_state }

      it 'tries to fetch it from the current country' do
        expect { described_method }.to change(Spree::Address, :count).by(1)
        expect(Spree::Address.last.state).to be_nil
      end

      context 'when the country requires a states' do
        before { country.update states_required: true }

        it 'fails creating the address' do
          expect { described_method }.not_to change(Spree::Address, :count)
        end
      end
    end

    it 'create an address' do
      expect { described_method }.to change(Spree::Address, :count).by(1)

      aggregate_failures do
        if SolidusSupport.combined_first_and_last_name_in_address?
          expect(address.name).to eq("John Doe")
        else
          expect(address.full_name).to eq("John Doe")
        end
        expect(address.address1).to eq('My Cool Address, n.1')
        expect(address.address2).to eq('')
        expect(address.city).to eq('My beautiful City')
        expect(address.zipcode).to eq('12345')
        expect(address.phone).to eq('(555)-123123123')
        expect(address.country).to eq(country)
        expect(address.state).to eq(state)
      end
    end

    it 'adds the address in the user addressbook and set it as ship/bill address' do
      expect { described_method }.to change(user.addresses, :count).by(1)
      expect(user.bill_address).to eq address
      expect(user.ship_address).to eq address
    end
  end
end
