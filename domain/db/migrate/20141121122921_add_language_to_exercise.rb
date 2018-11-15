class AddLanguageToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :language, :integer, default: 0
  end
end
