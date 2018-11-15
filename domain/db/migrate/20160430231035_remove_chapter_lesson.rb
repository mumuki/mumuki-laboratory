class RemoveChapterLesson < ActiveRecord::Migration[4.2]
  def change
    remove_column :lessons, :chapter_id
  end
end
