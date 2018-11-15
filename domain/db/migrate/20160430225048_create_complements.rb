class CreateComplements < ActiveRecord::Migration[4.2]
  def change
    create_table :complements do |t|
      t.references :guide, index: true
      t.references :book, index: true

      t.timestamps
    end
  end
end
