# frozen_string_literal: true

FactoryBot.define do
  factory :solidus_importer_row_address, class: 'SolidusImporter::Row' do
    data do
      {
        'First Name' => 'John',
        'Last Name' => 'Doe',
        'Address1' => 'My Cool Address, n.1',
        'Address2' => '',
        'City' => 'My beautiful City',
        'Zip' => '12345',
        'Phone' => '(555)-123123123',
        'Country Code' => 'US',
        'Province Code' => 'WA'
      }
    end

    trait :with_import do
      after(:build) do |row|
        row.import = build_stubbed(:solidus_importer_import_orders)
      end
    end
  end

  factory :solidus_importer_row_customer, class: 'SolidusImporter::Row' do
    data do
      { 'Email' => 'an_email@example.com' }.merge(build(:solidus_importer_row_address).data)
    end

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

    trait :with_tags do
      after(:build) { |row| row.data.merge!('Tags' => 'Tag1,Tag2, Tag3') }
    end

    trait :with_type do
      after(:build) { |row| row.data.merge!('Type' => 'Type1') }
    end
  end

  factory :solidus_importer_row_variant, class: 'SolidusImporter::Row' do
    data do
      {
        'Handle' => 'a-product-slug-2',
        'Variant SKU' => 'a-variant-sku',
        'Variant Weight' => 20.0,
        'Variant Price' => 60.5,
        'Variant Inventory Qty' => 5
      }
    end

    trait :with_import do
      after(:build) do |row|
        row.import = build_stubbed(:solidus_importer_import_products)
      end
    end
  end
end
