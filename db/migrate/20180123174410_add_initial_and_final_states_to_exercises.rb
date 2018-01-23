class AddInitialAndFinalStatesToExercises < ActiveRecord::Migration[5.1]
  def change
    add_column :exercises, :initial_state, :string
    add_column :exercises, :final_state, :string
  end
end
