class AddLoginMethodsToOrganization < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :login_methods, :string, array: true, default: Mumukit::Login::Settings.login_methods, null: false
  end
end
