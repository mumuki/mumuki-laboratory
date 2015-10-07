class Event::Submission < Event::Base
  def initialize(assignment)
    @assignment = assignment
  end

  def event_path
    'events/submissions'
  end

  def to_json
    as_json.to_json
  end

  def as_json
    @assignment.
      as_json(except: [:exercise_id, :submission_id, :id, :submitter_id, :solution, :created_at, :updated_at],
              include: {
                exercise: {only: [:id, :guide_id]},
                submitter: {only: [:id, :name]}}).
      merge('id' => @assignment.submission_id,
            'created_at' => @assignment.updated_at,
            'content' => @assignment.solution)
  end
end
