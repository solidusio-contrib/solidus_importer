# frozen_string_literal: true

require_relative 'address'

module SolidusImporter
  module Processors
    class BillAddress < Address
      def call(context)
        @data = context[:data]

        bill_address_attributes.empty? and return

        order = context.fetch(:order, {})

        order[:bill_address_attributes] = bill_address_attributes

        context.merge!(order: order)
      end

      def country_code
        @data['Billing Country Code'] || @data['Billing Country']
      end

      def province_code
        @data['Billing Province Code'] || @data['Billing Province']
      end

      def name
        @data['Billing Name'] || "#{firstname} #{lastname}"
      end

      def firstname
        @data['Billing First Name']
      end

      def lastname
        @data['Billing Last Name']
      end

      private

      def bill_address_attributes
        {
          name: name,
          address1: @data['Billing Address1'],
          address2: @data['Billing Address2'],
          city: @data['Billing City'],
          company: @data['Billing Company'],
          zipcode: @data['Billing Zip'],
          phone: @data['Billing Phone'],
          country: extract_country,
          state: extract_state
        }
      end
    end
  end
end
