class RemoveLanguageExtensions < ActiveRecord::Migration[4.2]
  def change
    remove_column :languages, :extension
    remove_column :languages, :test_extension
  end
end
