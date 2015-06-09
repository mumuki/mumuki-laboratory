module WithProgress

  def default_content_for(user)
    progress_for(user).content
  end

  def solved_by?(user)
    progress_for(user).solved?
  end

  def last_submission(user)
    progress_for(user).last_submission
  end

  def status_for(user)
    progress_for(user).status
  end

  def last_submission_date_for(user)
    progress_for(user).last_submission_date
  end

  private

  def progress_for(user)
    user.exercise_progress_for(self)
  end
end


