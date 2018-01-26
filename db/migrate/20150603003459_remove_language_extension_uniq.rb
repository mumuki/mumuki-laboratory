class RemoveLanguageExtensionUniq < ActiveRecord::Migration[4.2]
  def change
    remove_index :languages, :extension
    add_index :languages, :extension
  end
end
