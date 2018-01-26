class RenameChapterPositionToNumber < ActiveRecord::Migration[4.2]
  def change
    rename_column :chapters, :position, :number
  end
end
