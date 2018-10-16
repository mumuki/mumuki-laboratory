class AddHasMessagesToOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :has_messages, :boolean, default: false
  end
end
