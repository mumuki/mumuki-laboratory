class ChangeDefaultLoginMethods < ActiveRecord::Migration
  def change
    change_column :organizations, :login_methods, :string, array: true, default: Mumukit::Auth::LoginSettings.default_methods, null: false
  end
end
