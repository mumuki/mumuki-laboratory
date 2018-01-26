class RenameInvitationSlugToCode < ActiveRecord::Migration[4.2]
  def change
    rename_column :invitations, :slug, :code
  end
end
