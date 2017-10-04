class AddTriableToLanguage < ActiveRecord::Migration
  def change
    add_column :languages, :triable, :boolean, default: false
  end
end
