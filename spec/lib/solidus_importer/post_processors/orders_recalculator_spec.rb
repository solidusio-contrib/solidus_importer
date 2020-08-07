# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::PostProcessors::OrdersRecalculator do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }
    let(:order) { build(:order) }
    let(:context) { { order_ids: [123] } }

    it 'execute post_processors' do
      expect(Spree::Order).to receive(:find).with(123).and_return(order)
      expect(order).to receive(:recalculate)
      described_method
    end
  end
end
