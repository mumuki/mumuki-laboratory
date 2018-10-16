class RenameTenantToBook < ActiveRecord::Migration[4.2]
  def change
    rename_table :tenants, :books
  end
end
