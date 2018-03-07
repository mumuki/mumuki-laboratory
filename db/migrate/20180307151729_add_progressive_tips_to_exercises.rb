class AddProgressiveTipsToExercises < ActiveRecord::Migration[5.1]
  def change
    add_column :exercises, :progressive_tips, :text
  end
end
