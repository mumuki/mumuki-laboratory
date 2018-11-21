class RenameChoicesColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :exercises, :choices, :choice_values
    add_column :exercises, :choices, :text
  end
end
