class RenameChapterGuidePathToChapter < ActiveRecord::Migration
  def change
    rename_column :chapter_guides, :path_id, :chapter_id
  end
end
