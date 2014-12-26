class AddStatusToImport < ActiveRecord::Migration
  def change
    add_column :imports, :status, :integer, default: 0
  end
end

