class AddTestTemplateToLanguages < ActiveRecord::Migration[5.1]
  def change
    add_column :languages, :test_template, :text
  end
end
