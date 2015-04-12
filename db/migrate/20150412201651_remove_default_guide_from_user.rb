class RemoveDefaultGuideFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :default_guide_id
  end
end
