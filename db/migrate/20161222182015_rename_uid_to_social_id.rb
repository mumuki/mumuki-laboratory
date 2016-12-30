class RenameUidToSocialId < ActiveRecord::Migration
  def change
    rename_column :users, :uid, :social_id
  end
end
