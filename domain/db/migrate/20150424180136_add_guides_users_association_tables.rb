class AddGuidesUsersAssociationTables < ActiveRecord::Migration[4.2]
  def change
    create_table :collaborators do |t|
      t.integer :guide_id
      t.integer :user_id
    end
    create_table :contributors do |t|
      t.integer :guide_id
      t.integer :user_id
    end
    add_index :contributors, [:guide_id, :user_id], unique: true
    add_index :collaborators, [:guide_id, :user_id], unique: true
  end
end
