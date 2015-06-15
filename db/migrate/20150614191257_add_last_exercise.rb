class AddLastExercise < ActiveRecord::Migration
  def change
    add_reference :users, :last_exercise, null:true
  end
end
