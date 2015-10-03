class AddTypeToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :type, :string, default: 'Problem', null: false
  end
end