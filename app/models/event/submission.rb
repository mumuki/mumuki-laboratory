class Event::Submission < Event::Base
  def initialize(solution)
    @solution = solution
  end

  def event_path
    'events/submissions'
  end

  def event_json
    @solution.to_json(Rails.configuration.submission_notification_format)
  end
end
