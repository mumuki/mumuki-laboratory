class CreateTopics < ActiveRecord::Migration[4.2]
  def change
    create_table :topics do |t|
      t.string :name
      t.string :locale
      t.text :description

      t.timestamps
    end
  end
end
