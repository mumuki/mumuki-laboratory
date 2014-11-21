class AddLanguageToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :language, :integer, default: 0
  end
end
