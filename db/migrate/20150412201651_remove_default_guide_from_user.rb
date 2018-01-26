class RemoveDefaultGuideFromUser < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :default_guide_id
  end
end
