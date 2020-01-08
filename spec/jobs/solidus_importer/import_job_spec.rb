# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::ImportJob do
  describe '#perform' do
    subject(:described_method) { described_class.perform_now(import_id) }

    let(:import_id) {}

    it { expect { described_method }.to raise_error(ArgumentError) }

    context 'with a missing import' do
      let(:import_id) { 123 }

      it { expect { described_method }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'with a source file' do
      let(:import) { build_stubbed(:solidus_importer_import_customers) }
      let(:import_id) { import.id }
      let(:process_import) { instance_double(SolidusImporter::ProcessImport, process: nil) }

      before do
        allow(SolidusImporter::Import).to receive_messages(find: import)
        allow(SolidusImporter::ProcessImport).to receive(:new).with(import).and_return(process_import)
        described_method
      end

      it { expect(SolidusImporter::ProcessImport).to have_received(:new).with(import) }
      it { expect(process_import).to have_received(:process).with(no_args) }
    end
  end
end
