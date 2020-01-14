# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Row do
  subject(:described_instance) { described_class.new(args) }

  let(:args) {}

  it { expect(described_instance).not_to be_valid }

  context 'with a file entity and some row data' do
    let(:import) { build_stubbed(:solidus_importer_import_customers) }
    let(:args) { { import: import, data: { 'a_field' => a_value } } }

    it { expect(described_instance).to be_valid }
  end
end
