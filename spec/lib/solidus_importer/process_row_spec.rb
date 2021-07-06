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

  describe "#process" do
    subject(:process) { described_instance.process(context) }

    let(:context) { {} }

    let(:import) { create :solidus_importer_import_customers }
    let(:row) { create :solidus_importer_row_customer, import: import }

    context 'when a processor raises an exception' do
      let(:importer) {
        instance_double(
          SolidusImporter::BaseImporter,
          processors: [processor],
          handle_row_import: nil
        )
      }
      let(:processor) { SolidusImporter::Processors::Base }

      before do
        allow(processor).to receive(:call) { raise "Something bad happened" }
      end

      it "calls the configured exception handler" do
        # rubocop:disable RSpec/MessageSpies
        expect(SolidusImporter::Config.row_exception_handler).to receive(:call) do |exception, context|
          expect(exception.message).to eq "Something bad happened"
          expect(context[:importer]).to eq importer
          expect(context[:row_id]).to eq row.id
        end
        # rubocop:enable RSpec/MessageSpies

        process
      end
    end
  end
end
