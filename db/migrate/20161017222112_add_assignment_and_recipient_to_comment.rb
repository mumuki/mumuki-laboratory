class AddAssignmentAndRecipientToComment < ActiveRecord::Migration
  def change
    add_reference :comments, :assignment
    add_reference :comments, :recipient
  end
end
