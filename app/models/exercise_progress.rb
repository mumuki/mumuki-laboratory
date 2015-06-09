class ExerciseProgress < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  belongs_to :last_submission, class_name: 'Submission'

  delegate :content, to: :last_submission

  def solved?
    last_submission.passed?
  end

  def last_submission_date
    last_submission.created_at
  end

  def status
    case last_submission.status
      when 'passed' then :passed
      when 'failed' then :failed
      else :unknown
    end
  end
end
