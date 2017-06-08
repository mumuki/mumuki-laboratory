class AddHasMessagesToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :has_messages, :boolean, default: false
  end
end
