# frozen_string_literal: true

module SolidusImporter
  module Processors
    ##
    # This processor sends an email if the process of a single row is failing.
    #
    # Install: add the class to processors in solidus_importer configuration
    class NotifyOnFailure < Base
      def call(context)
        return if context[:success]

        ActionMailer::Base.mail(
          from: 'some_email',
          to: 'some_email_2',
          subject: 'Row process error',
          body: "Row context:\n#{context.to_json}"
        ).deliver_now
      end
    end
  end
end
