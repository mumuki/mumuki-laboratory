class ChangeInvitationExpirationDateType < ActiveRecord::Migration[4.2]
  def change
    change_column :invitations, :expiration_date, :datetime
  end
end
