class CreateSubmissions < ActiveRecord::Migration[4.2]
  def change
    create_table :submissions do |t|
      t.text :content
      t.references :exercise
      t.timestamps
    end
  end
end
