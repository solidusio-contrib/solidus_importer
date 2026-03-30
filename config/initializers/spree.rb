# frozen_string_literal: true

Spree::Backend::Config.configure do |config|
  config.menu_items << config.class::MenuItem.new(
    label: :importer,
    icon: 'download',
    condition: -> { can?(:admin, Spree::Product) },
    url: :admin_solidus_importer_imports_path
  )
end

MIME::Types.add(
  MIME::Type.new("content-type" => "application/csv", "extensions" => ["csv"]),
  true
)
