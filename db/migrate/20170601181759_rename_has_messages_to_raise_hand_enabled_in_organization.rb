class RenameHasMessagesToRaiseHandEnabledInOrganization < ActiveRecord::Migration
  def change
    rename_column :organizations, :has_messages, :raise_hand_enabled
  end
end
