class RemoveOriginalId < ActiveRecord::Migration
  def change
    remove_column :exercises, :original_id
  end
end
