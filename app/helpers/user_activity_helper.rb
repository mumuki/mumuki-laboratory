module UserActivityHelper
  def activity_selector_week_range_for(organization = Organization.current)
    start = organization.activity_start_date min_week
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
