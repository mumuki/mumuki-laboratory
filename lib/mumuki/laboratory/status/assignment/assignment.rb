module Mumuki::Laboratory::Status::Assignment
  include Mumuki::Laboratory::Status

  require_relative './unknown'
  require_relative './pending'
  require_relative './running'
  require_relative './passed'
  require_relative './failed'
  require_relative './errored'
  require_relative './aborted'
  require_relative './passed_with_warnings'
  require_relative './manual_evaluation_pending'

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

  def should_retry?
    group.should_retry?
  end

  def iconize
    group.iconize
  end

  def as_json(_options={})
    to_s
  end
end
