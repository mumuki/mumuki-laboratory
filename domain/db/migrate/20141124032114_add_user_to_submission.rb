class AddUserToSubmission < ActiveRecord::Migration[4.2]
  def change
    add_reference :submissions, :user, index: true
  end
end
