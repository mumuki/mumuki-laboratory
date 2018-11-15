class AddStatusToImport < ActiveRecord::Migration[4.2]
  def change
    add_column :imports, :status, :integer, default: 0
  end
end

