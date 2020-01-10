# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Utils do
  let(:dummy_instance) { Class.new.extend(described_class) }

  describe '#extract_attrs' do
    subject(:described_method) { dummy_instance.extract_attrs(data, mapping) }

    let(:data) { { 'a_key1' => 'a value 1', 'a_key2' => 'a value 2' } }
    let(:mapping) { {} }

    it { is_expected.to eq({}) }

    context 'with a mapping' do
      let(:mapping) { { 'a_key2' => 'target_key', 'a_key3' => 'another_key' } }

      it { expect(described_method).to eq('target_key' => 'a value 2') }
    end
  end
end
