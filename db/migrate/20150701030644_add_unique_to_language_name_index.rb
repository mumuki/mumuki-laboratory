class AddUniqueToLanguageNameIndex < ActiveRecord::Migration
  def change
    remove_index :languages, :name
    add_index :languages, :name, unique: true
  end
end
