class AddProgressiveTipsToExercises < ActiveRecord::Migration[5.1]
  def change
    add_column :exercises, :tips, :text
  end
end
