class RenamePathRuleToChapterGuide < ActiveRecord::Migration
  def change
    rename_table :path_rules, :chapter_guides
  end
end
