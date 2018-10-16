class AddBibliothecaIdToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :bibliotheca_id, :integer, default: nil
  end
end
