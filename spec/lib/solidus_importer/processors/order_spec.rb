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
        described_method
        expect(context[:order]).to match(hash_including(number: 'R123456789'))
      end
    end
  end
end
