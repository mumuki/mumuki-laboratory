class AddNewExpectationsToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :new_expectations, :boolean, default: false
  end
end
