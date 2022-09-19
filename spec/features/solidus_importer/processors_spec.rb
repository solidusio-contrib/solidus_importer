# frozen_string_literal: true

require 'spec_helper'

# TODO: the refactor breaks this, since we don't get custom options
# (processors and importer class) on the newly added Group Job
RSpec.xdescribe 'Set up a some processors' do
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
      context[:valid] = user.email.end_with?('@acme.com')
    }
  end
  let(:import_source) { create(:solidus_importer_import_customers) }
  let(:importer_options) do
    {
      importer: importer_class,
      processors: [processor_create_user, processor_check_domain]
    }
  end
  let(:importer) { importer_class.new(importer_options) }
  let(:importer_class) do
    Class.new(SolidusImporter::BaseImporter) do
      attr_accessor :checks

      def handle_row_import(ending_context)
        self.checks ||= []
        checks << ending_context[:valid]
      end
    end
  end

  before do
    allow(importer).to receive(:after_group_import).and_call_original
  end

  it 'creates 2 users and check the result' do
    expect { process_import }.to change(Spree::User, :count).from(0).to(2)

    expect(importer.checks).to eq [true, nil, nil, true]
  end
end
