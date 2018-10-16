class RemoveChapterLinksAndLongDescription < ActiveRecord::Migration[4.2]
  def change
    remove_column :chapters, :long_description
    remove_column :chapters, :links
  end
end
