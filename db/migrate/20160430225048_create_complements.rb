class CreateComplements < ActiveRecord::Migration
  def change
    create_table :complements do |t|
      t.references :guide, index: true
      t.references :book, index: true

      t.timestamps
    end
  end
end
