class AddEditorToProblem < ActiveRecord::Migration
  def change
    add_column :exercises, :editor, :integer, default: 0, null: false
    add_column :exercises, :choices, :string, array: true, default: [], null: false
  end
end
