class AddResultToImport < ActiveRecord::Migration
  def change
    add_column :imports, :result, :text
  end
end
