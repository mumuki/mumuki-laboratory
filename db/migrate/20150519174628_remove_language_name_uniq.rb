class RemoveLanguageNameUniq < ActiveRecord::Migration
  def change
    remove_index :languages, :name
    add_index :languages, :name
  end
end
