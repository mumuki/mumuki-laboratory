module Confirmable
  def submit_confirmation!(user)
    submit! user, Mumuki::Domain::Submission::Confirmation.new
  end
end
