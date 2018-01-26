class AddAuthorToExercise < ActiveRecord::Migration[4.2]
  def change
    add_reference :exercises, :author, index: true
  end
end
