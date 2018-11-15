class RemoveChapterNameDescription < ActiveRecord::Migration[4.2]
  def change
    remove_column :chapters, :name
    remove_column :chapters, :description
  end
end
