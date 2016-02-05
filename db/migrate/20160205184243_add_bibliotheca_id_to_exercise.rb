class AddBibliothecaIdToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :bibliotheca_id, :integer, default: nil
  end
end
