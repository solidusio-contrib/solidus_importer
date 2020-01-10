# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Customer < Base
      delegate :mapping, to: :@importer

      def call(_context)
        return @errors unless validate_row.nil?

        save_user
      end

      private

      def attrs
        @attrs ||= extract_attrs(@row.data, mapping)
      end

      def save_user
        @user = Spree::User.find_or_initialize_by(email: attrs[:email]) do |u|
          u.password = SecureRandom.alphanumeric(8)
        end
        @new_record = @user.new_record?
        update_context(@user, prepare_user && @user.save)
      end

      def prepare_user
        @user.assign_attributes(attrs)
        true
      rescue StandardError => e
        @messages = e.message
        false
      end

      def validate_row
        @errors =
          if !@row.is_a?(SolidusImporter::Row)
            { success: false, messages: 'Invalid row type' }
          elsif invalid_keys.any?
            { success: false, messages: 'Invalid keys in row data' }
          end
      end
    end
  end
end
