# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Address < Base
      def call(_)
        raise NotImplementedError
      end

      private

      def address
        @address ||= prepare_address
      end

      def persist_address
        return nil unless address.valid?

        address.tap(&:save!) if address.present? && !address.try(:persisted?)
      end

      def prepare_address
        raise NotImplementedError
      end

      def process_address
        address
      end

      def extract_country(iso)
        Spree::Country.find_by(iso: iso)
      end

      def extract_state(iso)
        Spree::State.find_by(abbr: iso) || Spree::State.find_by(name: iso)
      end
    end
  end
end
