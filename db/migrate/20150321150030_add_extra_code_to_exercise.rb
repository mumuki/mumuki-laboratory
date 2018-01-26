class AddExtraCodeToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :extra_code, :text
  end
end
