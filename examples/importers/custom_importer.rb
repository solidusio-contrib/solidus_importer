# frozen_string_literal: true

module SolidusImporter
  module Importers
    ##
    # This importer sends an email when the import process is finished.
    #
    # Install: set the class as importer in solidus_importer configuration
    class CustomImporter < ::SolidusImporter::BaseImporter
      def after_import(context)
        ActionMailer::Base.mail(
          from: 'some_email',
          to: 'some_email_2',
          subject: 'Import finished',
          body: "Ending context:\n#{context.to_json}"
        ).deliver_now
      end
    end
  end
end
