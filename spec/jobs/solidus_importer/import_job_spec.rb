# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::ImportJob do
  describe '#perform' do
    subject(:described_method) { described_class.perform_now(import_file, import_type) }

    let(:import_file) {}
    let(:import_type) {}

    it { expect { described_method }.to raise_error(ArgumentError) }

    context 'with an import file and type' do
      let(:import_file) { solidus_importer_fixture_path('customers.csv') }
      let(:import_type) { :customers }

      before do
        allow(SolidusImporter::ProcessImport).to receive(:import_from_file)
        described_method
      end

      it { expect(SolidusImporter::ProcessImport).to have_received(:import_from_file).with(import_file, import_type) }
    end

    context 'with an existing import model' do
      subject(:described_method) { described_class.perform_now(1) }

      let(:import) { build(:solidus_importer_import_customers) }
      let(:process_import) { spy }

      before do
        allow(SolidusImporter::Import).to receive(:find)
          .with(1)
          .and_return(import)

        allow(SolidusImporter::ProcessImport).to receive(:new)
          .with(import)
          .and_return(process_import)
      end

      it 'invoke #process on the existing import model' do
        described_method
        expect(process_import).to have_received(:process)
      end
    end

    context 'when the import model does not exist' do
      subject(:described_method) { described_class.perform_now(1) }

      it { expect { described_method }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
