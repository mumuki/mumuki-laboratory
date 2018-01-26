class CreateCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.string :locale
      t.string :image_url

      t.timestamps
    end
  end
end
