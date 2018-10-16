class AddOriginToExercise < ActiveRecord::Migration[4.2]
  def change
    add_reference :exercises, :origin, index: true
    add_column :exercises, :original_id, :integer, index: true
  end
end
