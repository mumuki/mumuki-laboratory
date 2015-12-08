class RenameCategoryToChapter < ActiveRecord::Migration
  def change
    rename_table :categories, :chapters
  end
end
