# frozen_string_literal: true

class CreateSolidusImporterImports < ActiveRecord::Migration[5.2]
  def change
    create_table :solidus_importer_imports do |t|
      t.string :import_type
      t.string :state, null: false, default: 'created', limit: 32
      t.string :file, null: false, default: '', limit: 1024
      t.text :messages

      t.timestamps null: false
    end

    reversible do |dir|
      dir.up { add_attachment :solidus_importer_imports, :file }
      dir.down { remove_attachment :solidus_importer_imports, :file }
    end
  end
end
