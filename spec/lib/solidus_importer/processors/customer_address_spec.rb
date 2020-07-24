# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::CustomerAddress do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { { data: data, user: user } }
    let(:user) { create(:user) }
    let(:country) { create :country, iso: 'US' }
    let(:state) { create :state, abbr: 'WA' }
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

    before do
      country
      state
    end

    it 'create an address and adds in the user addressbook' do
      expect { described_method }.to change(Spree::Address, :count).by(1)
                                       .and(change(user.addresses, :size).by(1))
    end

    context 'when the address is already present' do
      let(:user) {}

      it 'creates an address' do
        expect { described_method }.to change(Spree::Address, :count).by(1)
      end
    end

    context 'when the address is already present' do
      before do
        create(:address, {
                 firstname: 'John',
                 lastname: 'Doe',
                 address1: 'My Cool Address, n.1',
                 address2: '',
                 city: 'My beautiful City',
                 zipcode: '12345',
                 phone: '(555)-123123123',
                 country_id: country.id,
                 state_id: state.id
               })
      end

      it 'adds the address in user addressbook' do
        expect { described_method }.not_to change(Spree::Address, :count)
        expect(user.addresses.size).to eq 1
      end
    end
  end
end
