class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :course_id
      t.string :slug
      t.date :expiration_date
    end

    add_index :invitations, :slug, unique: true
  end
end
