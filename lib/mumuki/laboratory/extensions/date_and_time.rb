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
