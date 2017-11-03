class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :number
      t.references :book, index: true
      t.references :organization, index: true

      t.timestamps
    end
  end
end
