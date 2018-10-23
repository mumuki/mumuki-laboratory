class AddTestExtensionBack < ActiveRecord::Migration[5.1]
  def change
    add_column :languages, :test_extension, :string
  end
end
