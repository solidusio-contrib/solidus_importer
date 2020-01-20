# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Importers::Base do
  describe '.after_import' do
    it { expect(described_class).to respond_to(:after_import) }
  end

  describe '.before_import' do
    it { expect(described_class).to respond_to(:before_import) }
  end

  describe '.processors_list' do
    subject(:described_method) { described_class.processors_list }

    it { is_expected.to be_empty }
  end
end
