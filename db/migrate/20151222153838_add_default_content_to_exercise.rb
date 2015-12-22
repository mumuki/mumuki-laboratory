class AddDefaultContentToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :default_content, :string, null: true
  end
end
