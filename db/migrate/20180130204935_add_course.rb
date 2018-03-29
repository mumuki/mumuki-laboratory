class AddCourse < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :uid
      t.string :slug
      t.string :days, array: true
      t.string :code
      t.string :shifts, array: true
      t.string :period
      t.string :description
      t.integer :organization_id

      t.timestamps
    end
  end
end
