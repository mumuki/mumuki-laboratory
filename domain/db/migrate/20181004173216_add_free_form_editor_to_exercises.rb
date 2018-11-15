class AddFreeFormEditorToExercises < ActiveRecord::Migration[5.1]
  def change
    add_column :exercises, :free_form_editor_source, :text
  end
end
