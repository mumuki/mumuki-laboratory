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

module DateAndTime
  module Calculations
    # Polyfill, already implemented on Rails 5.2
    # https://api.rubyonrails.org/classes/DateAndTime/Calculations.html#method-i-prev_occurring
    def prev_occurring(day_of_week)
      ago = wday - DAYS_INTO_WEEK.fetch(day_of_week)
      ago += 7 unless ago > 0
      advance(days: -ago)
    end
  end
end
