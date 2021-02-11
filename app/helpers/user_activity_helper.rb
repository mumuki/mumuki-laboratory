module UserActivityHelper
  def activity_selector_week_range_for(organization = Organization.current)
    start = organization.activity_start_date min_week
    (start.prev_occurring(:monday) + 1..Date.today)
        .step(7)
        .to_a
        .reverse
        .map { |it| [it, it + 7.days] }
  end

  def mark_period_if_active(period_start)
    active_period?(period_start) && 'class=active'
  end

  private

  def active_period?(period_start)
    period_start ? @date_from == period_start : !@date_from
  end

  def min_week
    8.week.ago.to_date
  end
end
