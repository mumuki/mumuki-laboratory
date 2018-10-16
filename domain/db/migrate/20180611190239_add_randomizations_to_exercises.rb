class AddRandomizationsToExercises < ActiveRecord::Migration[5.1]
  def change
    add_column :exercises, :randomizations, :text
  end
end
