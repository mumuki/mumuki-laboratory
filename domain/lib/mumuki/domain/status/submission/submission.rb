module Mumuki::Domain::Status::Submission
  include Mumuki::Domain::Status
end

require_relative './pending'
require_relative './running'
require_relative './passed'
require_relative './failed'
require_relative './errored'
require_relative './aborted'
require_relative './passed_with_warnings'
require_relative './manual_evaluation_pending'

module Mumuki::Domain::Status::Submission
  STATUSES = [Pending, Running, Passed, Failed, Errored, Aborted, PassedWithWarnings, ManualEvaluationPending]

  test_selectors.each do |selector|
    define_method(selector) { false }
  end

  def group
    self
  end

  # Tells if a new, different submission should be tried.
  # True for `failed`, `errored` and `passed_with_warnings`
  def should_retry?
    false
  end

  def iconize
    group.iconize
  end

  def as_json(_options={})
    to_s
  end
end
