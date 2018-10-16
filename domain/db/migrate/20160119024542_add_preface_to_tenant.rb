class AddPrefaceToTenant < ActiveRecord::Migration[4.2]
  def change
    add_column :tenants, :preface, :text
  end
end
