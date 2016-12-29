class UserMode::MultiUser
  def can_visit?(user)
    user.student?
  end

end
