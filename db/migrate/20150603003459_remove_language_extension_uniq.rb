class RemoveLanguageExtensionUniq < ActiveRecord::Migration
  def change
    remove_index :languages, :extension
    add_index :languages, :extension
  end
end
