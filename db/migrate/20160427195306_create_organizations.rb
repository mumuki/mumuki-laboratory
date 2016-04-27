class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :contact_email
      t.text :description
      t.references :book, index: true

      t.timestamps
    end
  end
end
