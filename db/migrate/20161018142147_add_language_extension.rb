class AddLanguageExtension < ActiveRecord::Migration
  def change
    add_column :languages, :extension, :string, default: '', null: false
  end
end
