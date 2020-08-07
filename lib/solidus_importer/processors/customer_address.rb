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

        address.try(:valid?) || return

        user.addresses << address if user.present?
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
          country: extract_country(@data['Country Code']),
          state: extract_state(@data['Province Code'])
        )
      end
    end
  end
end
