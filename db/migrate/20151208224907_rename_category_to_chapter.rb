class RenameCategoryToChapter < ActiveRecord::Migration[4.2]
  def change
    rename_table :categories, :chapters
  end
end
