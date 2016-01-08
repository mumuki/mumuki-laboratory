class RenameExtraCode < ActiveRecord::Migration
  def change
    rename_column :exercises, :extra_code, :extra
  end
end
