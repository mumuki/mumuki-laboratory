class RenameExtraCode < ActiveRecord::Migration[4.2]
  def change
    rename_column :exercises, :extra_code, :extra
  end
end
