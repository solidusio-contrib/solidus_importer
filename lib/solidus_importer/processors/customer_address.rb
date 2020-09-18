# frozen_string_literal: true

module SolidusImporter
  module Processors
    class CustomerAddress < Base
      def call(context)
        @data = context.fetch(:data)

        address = Spree::Address.find_or_create_by(address_attributes)
        return unless address.valid?

        user = context.fetch(:user)
        user.addresses << address
        user.bill_address ||= address
        user.ship_address ||= address
        user.save!
      end

      private

      def country
        @country ||= Spree::Country.find_by(iso: @data['Country Code']) if @data['Country Code']
      end

      def state
        @state ||= country&.states&.find_by(abbr: @data['Province Code']) if @data['Province Code']
      end

      def address_attributes
        @address_attributes ||= {
          firstname: @data['First Name'],
          lastname: @data['Last Name'],
          address1: @data['Address1'],
          address2: @data['Address2'],
          city: @data['City'],
          zipcode: @data['Zip'],
          phone: @data['Phone'],
          country: country,
          state: state,
        }
      end
    end
  end
end
