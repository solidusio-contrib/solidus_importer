# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::PostProcessors::OrdersRecalculator do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let(:context) { { orders: [order] } }
    let(:order) { spy }

    it 'execute post_processors' do
      described_method
      expect(order).to have_received(:recalculate)
    end
  end
end
