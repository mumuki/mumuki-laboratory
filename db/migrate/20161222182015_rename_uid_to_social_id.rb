class RenameUidToSocialId < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :uid, :social_id
  end
end
