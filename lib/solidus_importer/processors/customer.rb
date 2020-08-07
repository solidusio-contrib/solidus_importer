# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Customer < Base
      def call(context)
        @data = context.fetch(:data)
        check_data

        context.merge!(user: process_user && persist_user)
      end

      def options
        @options ||= {
          password_method: ->(_user) { SecureRandom.alphanumeric(8) }
        }
      end

      private

      def check_data
        raise SolidusImporter::Exception, 'Missing required key: "Email"' if @data['Email'].blank?
      end

      def user
        @user ||= prepare_user
      end

      def prepare_user
        Spree::User.find_or_initialize_by(email: @data['Email']) do |u|
          u.password = options[:password_method].call(u)
        end
      end

      def process_user
        user
      end

      def persist_user
        user.tap(&:save!)
      end
    end
  end
end
