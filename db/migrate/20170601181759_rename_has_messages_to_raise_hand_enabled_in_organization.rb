class RenameHasMessagesToRaiseHandEnabledInOrganization < ActiveRecord::Migration[4.2]
  def change
    rename_column :organizations, :has_messages, :raise_hand_enabled
  end
end
