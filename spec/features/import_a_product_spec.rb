# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Import a product' do
  it 'creates the products in the database' do
    process_import = SolidusImporter.import_products solidus_importer_fixture_path('products.csv')
    expect(process_import.instance_eval{@import}.rows.size).to eq(7)
    pending "TODO: implement importer"
    expect(Spree::Product.count).to eq(1)
    product = Spree::Product.first

    aggregate_failures do
      expect(product.slug).to eq('hightop-sports-sneaker')
      expect(product.variants.count).to eq(3)
    end
  end
end
