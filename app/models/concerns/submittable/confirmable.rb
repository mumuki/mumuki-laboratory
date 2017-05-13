module Confirmable
  def submit_confirmation!(user)
    submit! user, Confirmation.new
    assignment_for user
  end
end
