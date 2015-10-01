class Event::Submission < Event::Base
  def initialize(assignment)
    @assignment = assignment
  end

  def event_path
    'events/submissions'
  end

  def event_json
    @assignment.as_json(Rails.configuration.submission_notification_format).merge(id: @assignment.submission_id).to_json
  end
end
