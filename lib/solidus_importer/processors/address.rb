# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Address < Base
      def call(context)
        @data = context.fetch(:data)

        return unless address?

        context.merge!(address: process_address)
      end

      private

      def process_address
        prepare_address.tap(&:save)
      end

      def prepare_address
        Spree::Address.new(
          firstname: @data['First Name'],
          lastname: @data['Last Name'],
          address1: @data['Address1'],
          address2: @data['Address2'],
          city: @data['City'],
          zipcode: @data['Zip'],
          phone: @data['Phone'],
          country: extract_country(@data['Country Code']),
          state: extract_state(@data['Province Code'])
        )
      end

      def extract_country(iso)
        Spree::Country.find_by(iso: iso)
      end

      def extract_state(iso)
        Spree::State.find_by(abbr: iso) || Spree::State.find_by(name: iso)
      end

      def address?
        @data['Address1'].present?
      end
    end
  end
end
