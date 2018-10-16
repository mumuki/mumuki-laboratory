class CreateLanguages < ActiveRecord::Migration[4.2]
  def change
    create_table :languages do |t|
      t.string :name
      t.string :test_runner_url
      t.string :extension
      t.string :image_url
      t.references :author, index: true

      t.timestamps
    end
  end
end
