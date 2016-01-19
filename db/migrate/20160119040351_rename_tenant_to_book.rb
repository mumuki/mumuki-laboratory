class RenameTenantToBook < ActiveRecord::Migration
  def change
    rename_table :tenants, :books
  end
end
