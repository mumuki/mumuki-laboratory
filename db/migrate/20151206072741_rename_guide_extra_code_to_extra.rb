class RenameGuideExtraCodeToExtra < ActiveRecord::Migration
  def change
    rename_column :guides, :extra_code, :extra
  end
end
