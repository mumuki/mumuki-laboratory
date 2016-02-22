class AddHiddenFlagToExtraCode < ActiveRecord::Migration
  def change
    add_column :exercises, :extra_visible, :boolean, default: false
  end
end
