class AddContactEmailToTenant < ActiveRecord::Migration[4.2]
  def change
    add_column :tenants, :contact_email, :string, null: false, default: 'info@mumuki.org'
  end
end
