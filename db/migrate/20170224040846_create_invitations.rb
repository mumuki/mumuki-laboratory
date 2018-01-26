class CreateInvitations < ActiveRecord::Migration[4.2]
  def change
    create_table :invitations do |t|
      t.string :slug
      t.string :course
      t.date :expiration_date
    end

    add_index :invitations, :slug, unique: true
  end
end
