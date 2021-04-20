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
    active_period?(period_start) ? 'nav-link active' : 'nav-link'
  end

  def solved_exercises_percentage
    percentage = @activity[:exercises][:solved_count].to_f / @activity[:exercises][:count] * 100
    "#{percentage.ceil}%"
  end

  def exercises_activity_stats
    solved_count = {
        name: t(:solved_exercises_count, count: @activity[:exercises][:solved_count]),
        value: @activity[:exercises][:solved_count] }
    solved_percentage = {
        name: t(:solved_exercises_percentage),
        value: solved_exercises_percentage }

    @date_from ? [solved_count] : [solved_count, solved_percentage]
  end

  def messages_activity_stats
    count = @activity[:messages][:count]
    approved = @activity[:messages][:approved]

    [{name: t(:messages_pluralized, count: count), value: count},
     {name: t(:approved_messages, count: approved), value: approved}]
  end

  private

  def active_period?(period_start)
    period_start ? @date_from == period_start : !@date_from
  end

  def min_week
    8.week.ago.to_date
  end
end
