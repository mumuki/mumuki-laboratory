class MakeOrganizationPrivateByDefault < ActiveRecord::Migration[4.2]
  def change
    change_column :organizations, :private, :boolean, default: true
  end
end
