class AddQueriableToLanguage < ActiveRecord::Migration
  def change
    add_column :languages, :queriable, :boolean, default: false
  end
end
