class RenameChapterGuidePathToChapter < ActiveRecord::Migration[4.2]
  def change
    rename_column :chapter_guides, :path_id, :chapter_id
  end
end
