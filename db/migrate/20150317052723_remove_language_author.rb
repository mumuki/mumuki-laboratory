class RemoveLanguageAuthor < ActiveRecord::Migration
  def change
    remove_column :languages, :plugin_author_id
  end
end
