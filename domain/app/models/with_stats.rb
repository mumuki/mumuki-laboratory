module WithStats
  def stats_for(user)
    Stats.from_statuses exercises.map { |it| it.status_for(user) }
  end

  def started?(user)
    stats_for(user).started?
  end
end
