# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Taxon < Base
      attr_accessor :product, :taxonomy

      def call(context)
        @data = context.fetch(:data)

        self.product = context.fetch(:product)

        process_taxons_type
        process_taxons_tags
      end

      private

      def options
        @options ||= {
          type_taxonomy: Spree::Taxonomy.find_or_create_by(name: 'Type'),
          tags_taxonomy: Spree::Taxonomy.find_or_create_by(name: 'Tags')
        }
      end

      def process_taxons_type
        product.taxons << prepare_taxon(type, options[:type_taxonomy])
      end

      def process_taxons_tags
        tags.map do |tag|
          product.taxons << prepare_taxon(tag, options[:tags_taxonomy])
        end
      end

      def prepare_taxon(name, taxonomy)
        Spree::Taxon.find_or_initialize_by(
          name: name,
          taxonomy_id: taxonomy.id
        )
      end

      def tags
        @data['Tags'].split(',').map(&:strip)
      end

      def type
        @data['Type']
      end
    end
  end
end
