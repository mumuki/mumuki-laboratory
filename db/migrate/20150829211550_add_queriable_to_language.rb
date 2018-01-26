class AddQueriableToLanguage < ActiveRecord::Migration[4.2]
  def change
    add_column :languages, :queriable, :boolean, default: false
  end
end
