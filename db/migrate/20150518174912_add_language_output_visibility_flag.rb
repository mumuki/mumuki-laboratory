class AddLanguageOutputVisibilityFlag < ActiveRecord::Migration[4.2]
  def change
    add_column :languages, :visible_success_output, :boolean, default: false
  end
end
