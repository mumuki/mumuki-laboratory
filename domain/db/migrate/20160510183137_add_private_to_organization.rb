class AddPrivateToOrganization < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :private, :boolean, default: false
  end
end
