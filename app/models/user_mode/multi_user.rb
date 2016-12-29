class UserMode::MultiUser

  def logo_url
    Organization.logo_url
  end

  def can_visit?(user)
    user.student?
  end

end
