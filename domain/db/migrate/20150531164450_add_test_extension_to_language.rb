class AddTestExtensionToLanguage < ActiveRecord::Migration[4.2]
  def change
    add_column :languages, :test_extension, :string
  end
end
