# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusImporter::Processors::Taxon do
  describe '#call' do
    subject(:described_method) { described_class.call(context) }

    let!(:shipping_category) { create :shipping_category }
    let(:context) { { data: data, product: product } }
    let(:product) { create :product }
    let(:data) { build(:solidus_importer_row_product, :with_import, :with_type, :with_tags).data }
    let(:tags_taxonomy) { Spree::Taxonomy.find_by(name: 'Tags') }
    let(:type_taxonomy) { Spree::Taxonomy.find_by(name: 'Type') }

    it 'create a taxon for each tag, related to the given taxonomy' do
      expect { described_method }.to change(product.taxons, :count).by(4)

      %w[Type1 Tag1 Tag2 Tag3].each do |taxon_name|
        expect(product.taxons.map(&:name)).to include(taxon_name)
      end

      expect(Spree::Taxon.find_by(name: 'Tag1').taxonomy).to eq tags_taxonomy
      expect(Spree::Taxon.find_by(name: 'Type1').taxonomy).to eq type_taxonomy
    end

    it 'creates "Type" and "Tags" taxonomies' do
      described_method
      expect(type_taxonomy).to be_present
      expect(tags_taxonomy).to be_present
    end
  end
end
