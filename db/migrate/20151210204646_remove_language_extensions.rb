class RemoveLanguageExtensions < ActiveRecord::Migration
  def change
    remove_column :languages, :extension
    remove_column :languages, :test_extension
  end
end
