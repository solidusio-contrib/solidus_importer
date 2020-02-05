# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Customer < Base
      def call(context)
        @data = context.fetch(:data)
        check_data
        context.merge!(user: process_user)
      end

      def options
        @options ||= {
          password_method: ->(_user) { SecureRandom.alphanumeric(8) }
        }
      end

      private

      def check_data
        raise SolidusImporter::Exception, 'Missing required key: "Email Address"' if @data['Email Address'].blank?
      end

      def prepare_user
        Spree::User.find_or_initialize_by(email: @data['Email Address']) do |u|
          u.password = options[:password_method].call(u)
        end
      end

      def process_user
        prepare_user.tap(&:save!)
      end
    end
  end
end
