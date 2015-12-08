class RenameChapterPositionToNumber < ActiveRecord::Migration
  def change
    rename_column :chapters, :position, :number
  end
end
