class AddExpectationsColumnToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :expectations, :text
  end
end
