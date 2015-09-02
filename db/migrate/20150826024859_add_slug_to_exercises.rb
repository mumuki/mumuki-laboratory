class AddSlugToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :slug, :string
    add_index :exercises, :slug, unique: true
  end
end
