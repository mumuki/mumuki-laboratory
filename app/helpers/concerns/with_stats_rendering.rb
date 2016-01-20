module WithStatsRendering
  def practice_key_for(stats)
    if stats && stats.started?
      :continue_practicing
    else
      :start_practicing
    end
  end
end
