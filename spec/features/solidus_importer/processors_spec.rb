# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Set up a some processors' do # rubocop:disable RSpec/DescribeClass
  subject(:process_import) do
    SolidusImporter::ProcessImport.new(
      import_source,
      importer_options: importer_options
    ).process
  end

  let(:processor_create_user) do
    ->(context) {
      user = Spree::User.new(email: context[:data]['Email'])
      user.password = 'a very secure password'
      context.merge!(success: user.save, user: user)
    }
  end
  let(:processor_check_domain) do
    ->(context) {
      user = context[:user].reload
      (context[:importer].checks ||= []) << user.email.end_with?('@example.com')
    }
  end
  let(:import_source) { create(:solidus_importer_import_customers) }
  let(:importer_options) do
    {
      importer: CustomImporter,
      processors: [processor_create_user, processor_check_domain]
    }
  end
  let(:importer) { CustomImporter.new(importer_options) }

  before do
    stub_const('CustomImporter', SolidusImporter::BaseImporter)
    CustomImporter.class_eval do
      attr_accessor :checks

      def after_import(ending_context)
        ending_context[:importer].checks
      end
    end
    importer
    allow(CustomImporter).to receive(:new).and_return(importer)
    allow(importer).to receive(:after_import).and_call_original
  end

  it 'creates 2 users and check the result' do
    expect { process_import }.to change(Spree::User, :count).from(0).to(2)
    expect(importer).to have_received(:after_import)
  end
end
