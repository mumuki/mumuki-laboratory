class RenamePositionToNumber < ActiveRecord::Migration
  def change
    rename_column :exercises, :position, :number
    rename_column :chapter_guides, :position, :number
  end
end
