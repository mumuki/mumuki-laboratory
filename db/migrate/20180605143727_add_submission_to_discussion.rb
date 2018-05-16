class AddSubmissionToDiscussion < ActiveRecord::Migration[5.1]
  def change
    add_reference :discussions, :submission
  end
end
