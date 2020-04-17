# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Address do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { { data: data } }
    let(:data) { create(:solidus_importer_row_address, :with_import).data }
    let!(:country) { create :country, iso: 'US' }
    let!(:state) { create :state, abbr: 'WA' }

    it 'create an address' do
      expect { described_method }.to change(Spree::Address, :count).from(0).to(1)
    end
  end
end
