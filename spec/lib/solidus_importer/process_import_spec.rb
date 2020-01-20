# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::ProcessImport do
  subject(:described_instance) { described_class.new(import) }

  describe '#process' do
    subject(:described_method) { described_instance.process }

    let(:rows_count) { import.rows.size }

    context 'with a CSV file with invalid headers' do
      let(:rows) { build_list(:solidus_importer_row_customer, 3) }
      let(:import) do
        create(:solidus_importer_import_customers, rows: rows).tap do |import|
          import.import_file = solidus_importer_fixture_path('invalid_headers.csv')
        end
      end

      it 'fails to import data' do
        expect(described_method.messages).to eq('Invalid headers')
        expect(described_method.state).to eq('failed')
      end
    end

    context 'with some rows' do
      let(:process_row) { instance_double(::SolidusImporter::ProcessRow, process: nil) }
      let(:rows) { build_list(:solidus_importer_row_customer, 3) }
      let(:import) { create(:solidus_importer_import_customers, rows: rows) }

      before do
        allow(::SolidusImporter::ProcessRow).to receive_messages(new: process_row)
        described_method
      end

      it { expect(::SolidusImporter::ProcessRow).to have_received(:new).exactly(rows_count).times }
    end

    context 'with completed rows' do
      let(:process_row) { instance_double(::SolidusImporter::ProcessRow, process: nil) }
      let(:rows) { build_list(:solidus_importer_row_customer, 3) }
      let!(:import) { create(:solidus_importer_import_customers, rows: rows) }

      before do
        allow(::SolidusImporter::ProcessRow).to receive_messages(new: process_row)
        import.rows.first.update_column(:state, :completed)
        described_method
      end

      it { expect(::SolidusImporter::ProcessRow).to have_received(:new).exactly(rows_count - 1).times }
    end

    context 'with force_scan option' do
      subject(:described_method) { described_instance.process(force_scan: force_scan) }

      let(:force_scan) { true }
      let(:import) { create(:solidus_importer_import_customers) }

      before do
        allow(CSV).to receive(:parse).and_call_original
        described_method
      end

      it { expect(CSV).to have_received(:parse) }

      context 'without force_scan option' do
        let(:force_scan) { false }

        it { expect(CSV).not_to have_received(:parse) }
      end
    end
  end
end
