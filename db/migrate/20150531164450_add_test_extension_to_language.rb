class AddTestExtensionToLanguage < ActiveRecord::Migration
  def change
    add_column :languages, :test_extension, :string
  end
end
