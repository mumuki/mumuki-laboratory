class AddLastOrganizationToUser < ActiveRecord::Migration
  def change
    add_reference :users, :last_organization, index: true
  end
end
