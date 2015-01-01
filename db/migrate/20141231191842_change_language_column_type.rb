class ChangeLanguageColumnType < ActiveRecord::Migration
  def change
    rename_column :exercises, :language, :language_id
    add_index :exercises, :language_id
  end
end
