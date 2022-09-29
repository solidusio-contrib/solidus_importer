class AddEntityIdToSolidusImporterRow < ActiveRecord::Migration[5.2]
  def change
    add_column :solidus_importer_rows, :entity_id, :string
  end
end
