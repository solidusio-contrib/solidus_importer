# frozen_string_literal: true

require_relative 'address'

module SolidusImporter
  module Processors
    class CustomerAddress < Address
      attr_accessor :user

      def call(context)
        @data = context.fetch(:data)

        self.user = context.fetch(:user)

        process_address && persist_address

        address.try(:valid?) or return
        user.present? or return

        user.addresses << address
      end

      def country_code
        @data['Country Code']
      end

      def province_code
        @data['Province Code']
      end

      private

      def prepare_address
        Spree::Address.find_or_initialize_by(
          firstname: @data['First Name'],
          lastname: @data['Last Name'],
          address1: @data['Address1'],
          address2: @data['Address2'],
          city: @data['City'],
          zipcode: @data['Zip'],
          phone: @data['Phone'],
          country: extract_country,
          state: extract_state
        )
      end
    end
  end
end
