class RenameChapterGuideToLesson < ActiveRecord::Migration
  def change
    rename_table :chapter_guides, :lessons
  end
end
