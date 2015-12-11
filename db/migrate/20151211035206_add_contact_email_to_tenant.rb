class AddContactEmailToTenant < ActiveRecord::Migration
  def change
    add_column :tenants, :contact_email, :string, null: false, default: 'info@mumuki.org'
  end
end
