class ChangeDefaultLoginMethods < ActiveRecord::Migration[4.2]
  def change
    change_column :organizations, :login_methods, :string, array: true, default: [:user_pass], null: false
  end
end
