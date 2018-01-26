class AddLanguageExtension < ActiveRecord::Migration[4.2]
  def change
    add_column :languages, :extension, :string, default: '', null: false
  end
end
