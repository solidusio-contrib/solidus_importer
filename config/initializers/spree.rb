# frozen_string_literal: true

Spree::Backend::Config.configure do |config|
  config.menu_items << if Spree.solidus_gem_version < Gem::Version.new("4.2.0")
    config.class::MenuItem.new(
      :imports,
      "download",
      condition: -> { can?(:admin, Spree::Product) },
      label: :importer,
      url: :admin_solidus_importer_imports_path
    )
  else
    config.class::MenuItem.new(
      icon: "download",
      condition: -> { can?(:admin, Spree::Product) },
      label: :importer,
      url: :admin_solidus_importer_imports_path
    )
  end
end

MIME::Types.add(
  MIME::Type.new("content-type" => "application/csv", "extensions" => ["csv"]),
  true
)
