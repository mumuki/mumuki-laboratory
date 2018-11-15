class AddUniqueIndexToOrganizationsName < ActiveRecord::Migration[5.1]
  def change
    add_index :organizations, :name, unique: true
  end
end
