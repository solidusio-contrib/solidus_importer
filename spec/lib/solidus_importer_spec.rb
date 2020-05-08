# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter do
  describe '.import!' do
    subject(:described_method) { described_class.import!('target-import.csv', type: 'customers') }

    it 'invokes ProcessImport#import_from_file' do
      expect(SolidusImporter::ProcessImport).to receive(:import_from_file).with('target-import.csv', :customers)
      subject
    end
  end
end
