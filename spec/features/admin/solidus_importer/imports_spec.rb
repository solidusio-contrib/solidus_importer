# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Imports', type: :feature do
  stub_authorization!

  describe 'New import form' do
    subject(:described_path) { spree.new_admin_solidus_importer_import_path }

    before do
      visit described_path
    end

    let(:import_file) { page.find 'input[name="solidus_importer_import[file]"]' }
    let(:import_button) do
      page.find 'button[type="submit"]'
    end

    it 'display import form with available types and "import!" button' do
      expect(import_file).to be_visible
      expect(page).to have_css('input[name="solidus_importer_import[import_type]"]', count: 3)
      expect(import_button).to be_visible
    end
  end

  describe 'Import create' do
    subject(:described_path) { spree.new_admin_solidus_importer_import_path }

    let!(:shipping_method) { create :shipping_method }

    let(:import_file) { page.find 'input[name="solidus_importer_import[file]"]' }
    let(:product_import_type) do
      page.find 'input[name="solidus_importer_import[import_type]"][value="products"]'
    end
    let(:orders_import_type) do
      page.find 'input[name="solidus_importer_import[import_type]"][value="orders"]'
    end
    let(:import_button) do
      page.find 'button[type="submit"]'
    end
    let(:products_csv_file) { solidus_importer_fixture_path('products.csv') }
    let(:import_type) { product_import_type }
    let(:no_import_type) { false }

    before do
      allow(::SolidusImporter::ImportJob).to receive(:perform_later)

      visit described_path
      import_file.set products_csv_file
      import_type.click unless no_import_type
      import_button.click
    end

    it 'creates a new import' do
      expect(::SolidusImporter::ImportJob).to have_received(:perform_later)
      expect(page).to have_content('Import has been successfully created!')
    end

    context 'when no import type is selected' do
      let(:no_import_type) { true }

      it 'fails creating a new import' do
        expect(page).to have_content("Import type can't be blank")
      end
    end

    context 'when the wrong import type is selected', skip: 'Not implemented yet' do
      let(:import_type) { orders_import_type }

      it 'fails creating a new import' do
        expect(page).to have_content('Import failed!')
      end
    end

    context 'when an invalid CSV file is selected', skip: 'Not implemented yet' do
      let(:products_csv_file) { 'unknow-file.csv' }

      it 'fails creating a new import' do
        expect(page).to have_content('Import failed!')
      end
    end
  end

  describe 'Imports index' do
    subject(:described_path) { spree.admin_solidus_importer_imports_path }

    let(:imports) {}

    before do
      imports
      visit described_path
    end

    it 'loads the imports listing' do
      expect(page.body).to include('No Import found')
    end

    context 'with some imports' do
      let(:imports) do
        [
          create(:solidus_importer_import_customers),
          create(:solidus_importer_import_orders),
          create(:solidus_importer_import_products)
        ]
      end

      it { expect(page).to have_css('.solidus_importer_import', count: imports.size) }
    end
  end

  describe 'Imports show' do
    subject(:described_path) { spree.admin_solidus_importer_import_path(import) }

    let(:import) { create(:solidus_importer_import_customers) }
    let(:rows) { [] }

    before do
      rows
      visit described_path
    end

    it 'loads the imports details' do
      expect(page).to have_css('[data-hook="admin_solidus_importer_imports_show"]')
      expect(page.body).to include('No Row found')
    end

    context 'with some rows' do
      let(:rows) { create_list(:solidus_importer_row_customer, 3, import: import) }

      it { expect(page).to have_css('.solidus_importer_import_row', count: rows.size) }
    end
  end
end
