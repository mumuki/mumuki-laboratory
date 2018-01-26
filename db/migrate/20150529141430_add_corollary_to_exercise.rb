class AddCorollaryToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :corollary, :text
  end
end
