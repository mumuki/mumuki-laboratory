class RenameInvitationSlugToCode < ActiveRecord::Migration
  def change
    rename_column :invitations, :slug, :code
  end
end
