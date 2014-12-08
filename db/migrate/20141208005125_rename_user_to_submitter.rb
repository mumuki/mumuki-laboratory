class RenameUserToSubmitter < ActiveRecord::Migration
  def change
    rename_column :submissions, :user_id, :submitter_id
  end
end
