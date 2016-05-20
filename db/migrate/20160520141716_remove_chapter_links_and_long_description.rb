class RemoveChapterLinksAndLongDescription < ActiveRecord::Migration
  def change
    remove_column :chapters, :long_description
    remove_column :chapters, :links
  end
end
