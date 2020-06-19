# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Import rows', type: :feature do
  stub_authorization!

  describe 'Imports show' do
    subject(:described_path) do
      spree.admin_solidus_importer_import_import_row_path(import_id: import.id, id: row.id)
    end

    let(:import) { build_stubbed(:solidus_importer_import_products) }
    let(:row) { build_stubbed(:solidus_importer_row_product, import: import) }
    let(:log_details) { '{"success":true,"id":2,"class_name":"Spree::Order","new_record":true}' }
    let(:log_entry) { instance_double(Spree::LogEntry, source: row, details: log_details) }

    before do
      allow(SolidusImporter::Row).to receive(:find_by!).and_return(row)
      allow(Spree::LogEntry).to receive(:find_by).and_return(log_entry)
      visit described_path
    end

    it 'loads the import row details' do
      expect(page).to have_css('[data-hook="admin_solidus_importer_import_rows_show"]')
      expect(page).to have_css('.import_row_attribute', count: row.data.keys.size)
      expect(page.body).to include(row.state)
    end
  end
end
