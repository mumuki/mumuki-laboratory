class DropCollaborators < ActiveRecord::Migration
  def change
    drop_table :collaborators
  end
end
