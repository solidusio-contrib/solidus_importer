# frozen_string_literal: true

module SolidusImporter
  module Processors
    class ShipAddress < Base
      def call(context)
        @data = context[:data]

        return if @data['Shipping Address1'].blank?

        order = context.fetch(:order, {})

        order[:ship_address_attributes] = ship_address_attributes

        context.merge!(order: order)
      end

      private

      def country_code
        @data['Shipping Country Code']
      end

      def province_code
        @data['Shipping Province Code']
      end

      def firstname
        @data['Shipping First Name']
      end

      def lastname
        @data['Shipping Last Name']
      end

      def name
        "#{firstname} #{lastname}".strip
      end

      def ship_address_attributes
        name_attrs = if SolidusImporter.combined_first_and_last_name_in_address?
                       { name: name }
                     else

                       { firstname: firstname, lastname: lastname }
                     end

        {
          address1: @data['Shipping Address1'],
          address2: @data['Shipping Address2'],
          city: @data['Shipping City'],
          company: @data['Shipping Company'],
          zipcode: @data['Shipping Zip'],
          phone: @data['Shipping Phone'],
          country: country,
          state: state,
        }.merge(name_attrs)
      end

      def country
        @country ||= Spree::Country.find_by(iso: country_code) if country_code
      end

      def state
        @state ||= country&.states&.find_by(abbr: province_code) if province_code
      end
    end
  end
end
