# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Import do
  subject(:import) { described_class.new(import_type: :customers, import_file: import_file) }

  let(:import_file) { solidus_importer_fixture_path('customers.csv') }

  it { is_expected.to be_valid }

  context "with no file attached" do
    let(:import_file) { nil }

    it "will not be valid" do
      expect{ import.save! }.to raise_exception SolidusImporter::Exception, "Existing file required"
    end
  end

  describe '#finished?' do
    before do
      import.rows = rows
    end

    let(:rows) { create_list(:solidus_importer_row_customer, 2, state: :completed, import: subject) }

    it "is considered finished when all rows are completed" do
      expect(import).to be_finished
    end

    context "when any of the rows are failed" do
      before do
        rows.last.update!(state: :failed)
      end

      it { is_expected.to be_finished }
    end

    context "when any of the rows are processing" do
      before do
        rows.last.update!(state: :processing)
      end

      it { is_expected.not_to be_finished }
    end
  end
end
