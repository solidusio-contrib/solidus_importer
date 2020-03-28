# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Import from CSV files' do # rubocop:disable RSpec/DescribeClass
  subject(:import) { SolidusImporter::ProcessImport.import_from_file(import_file, import_type) }

  let(:import_file) {}
  let(:import_type) {}

  before { allow(Spree::LogEntry).to receive(:create!) }

  context 'with a customers source file' do
    let(:import_file) { solidus_importer_fixture_path('customers.csv') }
    let(:import_type) { :customers }
    let(:csv_file_rows) { 2 }
    let(:user_emails) { ['jane.doe01520022060@example.com', 'jane.doe11520022060@example.com'] }

    it 'imports some customers' do
      expect { import }.to change(Spree::User, :count).by(2)
      expect(Spree::User.where(email: user_emails).count).to eq(2)
      expect(import.state).to eq('completed')
      expect(Spree::LogEntry).to have_received(:create!).exactly(csv_file_rows).times
    end
  end

  context 'with a products file' do
    let(:import_file) { solidus_importer_fixture_path('products.csv') }
    let(:import_type) { :products }
    let(:csv_file_rows) { 7 }
    let(:product_slug) { 'hightop-sports-sneaker' }
    let(:image_url) { 'https://cdn.shopify.com/shopify-marketing_assets/static/tobias-lutke-shopify.jpg' }
    let!(:shipping_category) { create(:shipping_category) }

    before do
      allow(URI).to receive(:open).and_call_original
      allow(URI).to receive(:open).with(image_url) do
        File.open(solidus_importer_fixture_path('thinking-cat.jpg'))
      end
    end

    it 'imports some products' do # rubocop:disable RSpec/MultipleExpectations
      expect { import }.to change(Spree::Product, :count).by(1)
      product = Spree::Product.last
      expect(product.variants.count).to eq(3)
      expect(product.slug).to eq(product_slug)
      expect(import.state).to eq('completed')
      expect(product.images).not_to be_empty
      expect(product.option_types.count).to eq 2
      expect(Spree::Product.last.images).not_to be_empty
      expect(Spree::Variant.last.images).not_to be_empty
      expect(Spree::LogEntry).to have_received(:create!).exactly(csv_file_rows).times
    end
  end

  context 'with an invalid products file' do
    let(:import_file) { solidus_importer_fixture_path('invalid_product.csv') }
    let(:import_type) { :products }
    let!(:shipping_category) { create(:shipping_category) }

    it 'fails to import the product' do
      expect { import }.not_to change(Spree::Product, :count)
      expect(import.rows.first.messages).to eq("Validation failed: Name can't be blank")
    end
  end

  context 'with a orders file' do
    let(:import_file) { solidus_importer_fixture_path('orders.csv') }
    let(:import_type) { :orders }
    let(:csv_file_rows) { 4 }
    let(:order_numbers) { ['#MA-1097', '#MA-1098'] }
    let!(:store) { create(:store) }

    it 'imports some orders' do
      expect { import }.to change(Spree::Order, :count).by(2)
      expect(Spree::Order.where(number: order_numbers).count).to eq(2)
      expect(import.state).to eq('completed')
      expect(Spree::LogEntry).to have_received(:create!).exactly(csv_file_rows).times
    end
  end
end
