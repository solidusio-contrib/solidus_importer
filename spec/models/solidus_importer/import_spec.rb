# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Import do
  subject(:described_instance) { described_class.new }

  it { expect(described_instance).not_to be_valid }

  context 'with an import file and type' do
    before do
      described_instance.import_type = :customers
      described_instance.import_file = solidus_importer_fixture_path('customers.csv')
    end

    it { expect(described_instance).to be_valid }
  end

  describe '#import_file=' do
    subject(:described_method) { described_instance.import_file = some_file }

    let(:some_file) { nil }

    it { expect { described_method }.to raise_error(SolidusImporter::Exception) }

    context 'with a file' do
      let(:some_file) { __FILE__ }

      it { expect { described_method }.to change { described_instance.file.present? }.from(false).to(true) }
    end
  end

  describe '#finished?' do
    subject(:described_method) { described_instance.finished? }

    let(:rows) { OpenStruct.new }
    let(:finished_rows) { [] }
    let(:size) { 0 }

    before do
      allow(rows).to receive_messages(failed_or_completed: finished_rows, size: size)
      allow(described_instance).to receive_messages(rows: rows)
    end

    it { is_expected.to be_truthy }

    context 'with some rows' do
      let(:finished_rows) { [1, 2] }
      let(:size) { 3 }

      it { is_expected.to be_falsey }

      context 'with the size equals to the number of failed or completed rows' do
        let(:size) { finished_rows.size }

        it { is_expected.to be_truthy }
      end
    end
  end
end
