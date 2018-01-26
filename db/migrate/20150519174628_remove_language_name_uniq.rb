class RemoveLanguageNameUniq < ActiveRecord::Migration[4.2]
  def change
    remove_index :languages, :name
    add_index :languages, :name
  end
end
