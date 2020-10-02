# frozen_string_literal: true

module SolidusImporter
  module Processors
    class BillAddress < Base
      def call(context)
        @data = context[:data]

        return if @data['Billing Address1'].blank?

        order = context.fetch(:order, {})

        order[:bill_address_attributes] = bill_address_attributes

        context.merge!(order: order)
      end

      private

      def country_code
        @data['Billing Country Code']
      end

      def province_code
        @data['Billing Province Code']
      end

      def bill_address_attributes
        {
          firstname: @data['Billing First Name'],
          lastname: @data['Billing Last Name'],
          address1: @data['Billing Address1'],
          address2: @data['Billing Address2'],
          city: @data['Billing City'],
          company: @data['Billing Company'],
          zipcode: @data['Billing Zip'],
          phone: @data['Billing Phone'],
          country: country,
          state: state
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
