class AddTypeToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :type, :string, default: 'Problem', null: false
  end
end