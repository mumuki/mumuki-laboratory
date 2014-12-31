class RenameAuthorToPluginAuthor < ActiveRecord::Migration
  def change
    rename_column :languages, :author_id, :plugin_author_id
  end
end
