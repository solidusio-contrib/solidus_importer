# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::ProcessRow do
  subject(:described_instance) { described_class.new(importer, row) }

  let(:importer) {}
  let(:row) {}

  it { expect { described_instance }.to raise_error(SolidusImporter::Exception, 'No importer defined') }

  context 'with an importer' do
    let(:importer) { instance_double('AnImporter') }

    it { expect { described_instance }.to raise_error(SolidusImporter::Exception, 'Invalid row type') }

    context 'with a row' do
      let(:row) { SolidusImporter::Row.new }

      it { expect(described_instance).to be_instance_of(described_class) }
    end
  end

  describe '#process' do
    subject(:process) { described_instance.process(context) }

    let(:row) { create(:solidus_importer_row_order, import: import) }
    let(:import) { create(:solidus_importer_import_orders) }
    let(:importer) { SolidusImporter::BaseImporter.new({}) }
    let(:context) { {} }

    it 'preserve the context' do
      expect(process).to be_an_instance_of(Hash)
    end
  end
end
