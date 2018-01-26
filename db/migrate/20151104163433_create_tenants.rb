class CreateTenants < ActiveRecord::Migration[4.2]
  def change
    create_table :tenants do |t|
      t.string :name, unique: true

      t.timestamps
    end
  end
end
