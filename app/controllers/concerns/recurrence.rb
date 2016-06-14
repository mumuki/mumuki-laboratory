module Recurrence
  def visitor_recurrent?
    current_user? && current_user.last_guide.present?
  end
end
