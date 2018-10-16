class AddTriableToLanguage < ActiveRecord::Migration[4.2]
  def change
    add_column :languages, :triable, :boolean, default: false
  end
end
