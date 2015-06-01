class AddCorollaryToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :corollary, :text
  end
end
