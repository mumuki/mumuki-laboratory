class AddEditorToProblem < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :editor, :integer, default: 0, null: false
    add_column :exercises, :choices, :string, array: true, default: [], null: false
  end
end
