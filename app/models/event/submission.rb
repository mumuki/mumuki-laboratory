class Event::Submission < Event::Base
  def initialize(solution)
    @solution = solution
  end

  def event_path
    'events/submissions'
  end

  def event_json
    @solution.as_json(Rails.configuration.submission_notification_format).merge(id: @solution.submission_id)
  end
end
