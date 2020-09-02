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

    it 'create an address' do
      expect { described_method }.to change(Spree::Address, :count).by(1)
    end

    it 'adds the address in the user addressbook' do
      expect { described_method }.to change(user.addresses, :count).by(1)
    end
  end
end
