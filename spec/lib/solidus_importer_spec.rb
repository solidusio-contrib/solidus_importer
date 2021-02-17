# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter do
  describe '.import!' do
    subject(:described_method) { described_class.import!('target-import.csv', type: 'customers') }

    before do
      allow(SolidusImporter::ProcessImport).to receive(:import_from_file)
    end

    it 'invokes ProcessImport#import_from_file' do
      described_method
      expect(SolidusImporter::ProcessImport).to have_received(:import_from_file).with('target-import.csv', :customers)
    end
  end
end
