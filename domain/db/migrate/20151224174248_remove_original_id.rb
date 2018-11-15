class RemoveOriginalId < ActiveRecord::Migration[4.2]
  def change
    remove_column :exercises, :original_id
  end
end
