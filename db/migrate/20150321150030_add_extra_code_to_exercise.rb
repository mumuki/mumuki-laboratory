class AddExtraCodeToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :extra_code, :text
  end
end
