# frozen_string_literal: true

FactoryBot.define do
  factory :solidus_importer_row_customer, class: 'SolidusImporter::Row' do
    data { { 'Email' => 'an_email@example.com' } }

    trait :with_import do
      after(:build) do |row|
        row.import = build_stubbed(:solidus_importer_import_customers)
      end
    end
  end

  factory :solidus_importer_row_order, class: 'SolidusImporter::Row' do
    data { { 'Name' => 'R123456789', 'Email' => 'an_email@example.com', 'Currency' => 'USD', 'Note' => nil } }

    trait :with_import do
      after(:build) do |row|
        row.import = build_stubbed(:solidus_importer_import_orders)
      end
    end
  end

  factory :solidus_importer_row_product, class: 'SolidusImporter::Row' do
    data { { 'Handle' => 'a-product-slug', 'Title' => 'A product name' } }

    trait :with_import do
      after(:build) do |row|
        row.import = build_stubbed(:solidus_importer_import_products)
      end
    end
  end

  factory :solidus_importer_row_variant, class: 'SolidusImporter::Row' do
    data { { 'Handle' => 'a-product-slug-2', 'Variant SKU' => 'a-variant-sku', 'Variant Weight' => 20.0 } }

    trait :with_import do
      after(:build) do |row|
        row.import = build_stubbed(:solidus_importer_import_products)
      end
    end
  end
end
