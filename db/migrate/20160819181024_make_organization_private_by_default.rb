class MakeOrganizationPrivateByDefault < ActiveRecord::Migration
  def change
    change_column :organizations, :private, :boolean, default: true
  end
end
