class AddDefaultContentToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :default_content, :string, null: true
  end
end
