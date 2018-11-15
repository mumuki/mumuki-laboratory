class DropCollaborators < ActiveRecord::Migration[4.2]
  def change
    drop_table :collaborators
  end
end
