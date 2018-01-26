class AddExpectationsColumnToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :expectations, :text
  end
end
