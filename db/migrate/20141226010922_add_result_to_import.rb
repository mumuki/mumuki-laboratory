class AddResultToImport < ActiveRecord::Migration[4.2]
  def change
    add_column :imports, :result, :text
  end
end
