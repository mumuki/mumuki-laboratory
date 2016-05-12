class AddOrganizationImage < ActiveRecord::Migration
  def change
    add_column :organizations, :logo_url, :string
  end
end
