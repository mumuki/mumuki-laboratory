class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.text :content
      t.references :exercise
      t.timestamps
    end
  end
end
