class RenameGuideExtraCodeToExtra < ActiveRecord::Migration[4.2]
  def change
    rename_column :guides, :extra_code, :extra
  end
end
