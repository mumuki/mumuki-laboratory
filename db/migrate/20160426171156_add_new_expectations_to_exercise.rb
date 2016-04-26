class AddNewExpectationsToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :new_expectations, :boolean, default: false
  end
end
