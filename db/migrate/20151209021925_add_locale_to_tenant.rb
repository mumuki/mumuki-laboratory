class AddLocaleToTenant < ActiveRecord::Migration[4.2]
  def change
    add_column :tenants, :locale, :string, default: :en
  end
end
