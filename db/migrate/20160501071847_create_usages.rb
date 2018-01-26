class CreateUsages < ActiveRecord::Migration[4.2]
  def change
    create_table :usages do |t|
      t.references :organization, index: true
      t.string :slug
      t.references :item, polymorphic: true, index: true
      t.references :parent_item, polymorphic: true, index: true
      t.timestamps
    end
  end
end
