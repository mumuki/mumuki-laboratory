class AddLanguageOutputVisibilityFlag < ActiveRecord::Migration
  def change
    add_column :languages, :visible_success_output, :boolean, default: false
  end
end
