class AddLocaleToTenant < ActiveRecord::Migration
  def change
    add_column :tenants, :locale, :string, default: :en
  end
end
