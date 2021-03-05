# frozen_string_literal: true

FactoryBot.define do
  factory :solidus_importer_import_customers, class: 'SolidusImporter::Import' do
    import_type { :customers }

    after(:build) do |import|
      import.import_file = solidus_importer_fixture_path('customers.csv')
    end
  end

  factory :solidus_importer_import_orders, class: 'SolidusImporter::Import' do
    import_type { :orders }

    after(:build) do |import|
      import.import_file = solidus_importer_fixture_path('orders.csv')
    end
  end

  factory :solidus_importer_import_products, class: 'SolidusImporter::Import' do
    import_type { :products }

    after(:build) do |import|
      import.import_file = solidus_importer_fixture_path('products.csv')
    end
  end
end
