class RemoveChapterNameDescription < ActiveRecord::Migration
  def change
    remove_column :chapters, :name
    remove_column :chapters, :description
  end
end
