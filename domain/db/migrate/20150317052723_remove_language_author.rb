class RemoveLanguageAuthor < ActiveRecord::Migration[4.2]
  def change
    remove_column :languages, :plugin_author_id
  end
end
