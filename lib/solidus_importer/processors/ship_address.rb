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

      def ship_address_attributes
        {
          firstname: @data['Shipping First Name'],
          lastname: @data['Shipping Last Name'],
          address1: @data['Shipping Address1'],
          address2: @data['Shipping Address2'],
          city: @data['Shipping City'],
          company: @data['Shipping Company'],
          zipcode: @data['Shipping Zip'],
          phone: @data['Shipping Phone'],
          country: country,
          state: state,
        }
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
