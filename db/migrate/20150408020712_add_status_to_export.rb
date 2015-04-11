class AddStatusToExport < ActiveRecord::Migration
  def change
    add_column :exports, :status, :integer, default: 0
    add_column :exports, :result, :text
  end
end
