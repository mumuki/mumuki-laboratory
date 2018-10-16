class RenameAuthorToPluginAuthor < ActiveRecord::Migration[4.2]
  def change
    rename_column :languages, :author_id, :plugin_author_id
  end
end
