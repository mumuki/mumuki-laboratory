module GuidesHelper

  def stats(stats, k)
    "#{stats.send k} #{status_icon(k)} ".html_safe
  end

  def practice_key_for(stats)
    if stats && stats.started?
      :continue_practicing
    else
      :start_practicing
    end
  end

end
