module Mumuki::Laboratory::Status::Submission
  include Mumuki::Laboratory::Status
end

require_relative './pending'
require_relative './running'
require_relative './passed'
require_relative './failed'
require_relative './errored'
require_relative './aborted'
require_relative './passed_with_warnings'
require_relative './manual_evaluation_pending'

module Mumuki::Laboratory::Status::Submission
  STATUSES = [Pending, Running, Passed, Failed, Errored, Aborted, PassedWithWarnings, ManualEvaluationPending]

  def group
    self
  end

  def passed?
    false
  end

  def failed?
    false
  end

  def errored?
    false
  end

  def aborted?
    false
  end

  def should_retry?
    true
  end

  def iconize
    group.iconize
  end

  def as_json(_options={})
    to_s
  end
end
