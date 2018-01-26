class AddOrganizationImage < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :logo_url, :string
  end
end
