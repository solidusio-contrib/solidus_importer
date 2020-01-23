# frozen_string_literal: true

module SolidusImporter
  module Processors
    class Customer < Base
      def call(context)
        @data = context.fetch(:data)
        context.merge!(check_data || save_user)
      end

      def options
        @options ||= {
          password_method: ->(_user) { SecureRandom.alphanumeric(8) }
        }
      end

      private

      def check_data
        if @data.blank?
          { success: false, messages: 'Missing input data' }
        elsif @data['Email Address'].blank?
          { success: false, messages: 'Missing required key: "Email Address"' }
        end
      end

      def prepare_user
        Spree::User.find_or_initialize_by(email: @data['Email Address']) do |u|
          u.password = options[:password_method].call(u)
        end
      end

      def save_user
        user = prepare_user
        {
          new_record: user.new_record?,
          success: user.save,
          user: user,
          messages: user.errors.full_messages.join(', ')
        }
      end
    end
  end
end
