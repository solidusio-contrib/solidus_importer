# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Imports', type: :feature do
  stub_authorization!

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
