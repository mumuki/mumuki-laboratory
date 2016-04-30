class RemoveChapterLesson < ActiveRecord::Migration
  def change
    remove_column :lessons, :chapter_id
  end
end
