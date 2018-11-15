class AddManualEvaluationToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :manual_evaluation, :boolean, default: false
  end
end
