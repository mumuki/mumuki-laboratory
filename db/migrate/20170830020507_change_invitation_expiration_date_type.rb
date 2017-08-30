class ChangeInvitationExpirationDateType < ActiveRecord::Migration
  def change
    change_column :invitations, :expiration_date, :datetime
  end
end
