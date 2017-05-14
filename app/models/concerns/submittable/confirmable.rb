module Confirmable
  def submit_confirmation!(user)
    submit! user, Confirmation.new
  end
end
