class AddLastExercise < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :last_exercise, null:true
  end
end
