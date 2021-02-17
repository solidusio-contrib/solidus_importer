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

      def firstname
        @data['First Name']
      end

      def lastname
        @data['Last Name']
      end

      def name
        "#{firstname} #{lastname}".strip
      end

      def address_attributes
        name_attrs = if SolidusImporter.combined_first_and_last_name_in_address?
                       { name: name }
                     else

                       { firstname: firstname, lastname: lastname }
                     end
        {
          address1: @data['Address1'],
          address2: @data['Address2'],
          city: @data['City'],
          zipcode: @data['Zip'],
          phone: @data['Phone'],
          country: country,
          state: state,
        }.merge(name_attrs)
      end
    end
  end
end
