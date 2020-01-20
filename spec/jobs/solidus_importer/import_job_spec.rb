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
  end
end
