module UserActivityHelper
  def activity_selector_week_range
    start = min_week.max Organization.current.in_preparation_until
    (start.prev_occurring(:monday) + 1..Date.today)
        .step(7)
        .to_a
        .reverse
        .map { |it| [it, it + 7.days] }
  end

  private

  def min_week
    8.week.ago.to_date
  end
end

class Date
  def max(other)
    return self unless other
    other > self ? other.to_date : self
  end
end
