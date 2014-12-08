class AddAuthorToExercise < ActiveRecord::Migration
  def change
    add_reference :exercises, :author, index: true
  end
end
