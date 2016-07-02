class AddLoginMethodsToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :login_methods, :string, array: true, default: Mumukit::Auth::LoginSettings.defaults, null: false
  end
end
