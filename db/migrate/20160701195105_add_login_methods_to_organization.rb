class AddLoginMethodsToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :login_methods, :string, array: true, default: Mumukit::Login::Settings.login_methods, null: false
  end
end
