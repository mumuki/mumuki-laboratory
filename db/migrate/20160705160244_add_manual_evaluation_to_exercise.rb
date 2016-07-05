class AddManualEvaluationToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :manual_evaluation, :boolean, default: false
  end
end
