# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Address < Base
      def call(_)
        raise NotImplementedError
      end

      def country_code
        raise NotImplementedError
      end

      def province_code
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

      def extract_country(iso = country_code)
        @extract_country ||= Spree::Country.find_by(iso: iso)
      end

      def extract_state(code = province_code)
        @extract_state and return @extract_state

        @extract_state ||= extract_country&.states&.find_by(abbr: code)
      end
    end
  end
end
