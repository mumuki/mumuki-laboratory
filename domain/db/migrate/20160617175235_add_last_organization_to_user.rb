class AddLastOrganizationToUser < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :last_organization, index: true
  end
end
