module WithMenuBar
  def writer?
    current_user? && current_user.writer?
  end

  def teacher?
    current_user? && current_user.teacher?
  end

  def janitor?
    current_user? && current_user.janitor?
  end
end
