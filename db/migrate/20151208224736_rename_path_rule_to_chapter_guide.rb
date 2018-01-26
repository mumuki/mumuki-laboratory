class RenamePathRuleToChapterGuide < ActiveRecord::Migration[4.2]
  def change
    rename_table :path_rules, :chapter_guides
  end
end
