class RenameChapterGuideToLesson < ActiveRecord::Migration[4.2]
  def change
    rename_table :chapter_guides, :lessons
  end
end
