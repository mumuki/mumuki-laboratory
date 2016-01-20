class AddPrefaceToTenant < ActiveRecord::Migration
  def change
    add_column :tenants, :preface, :text
  end
end
