module Mumuki::Laboratory::Status
  def self.load(i)
    cast(i)
  end

  def self.dump(status)
    if status.is_a? Numeric
      status
    else
      coerce(status).to_i
    end
  end

  def self.from_sym(status)
    "Mumuki::Laboratory::Status::#{status.to_s.camelize}".constantize
  end

  def self.coerce(status_like) # TODO make polymorphic to_mumuki_status
    if status_like.is_a? Symbol
      from_sym(status_like)
    elsif status_like.is_a? Mumuki::Laboratory::Status::Base
      status_like
    else
      status_like.status
    end
  end

  def self.cast(i)
    STATUSES[i.to_i]
  end
end

require_relative './status/base'
require_relative './status/unknown'
require_relative './status/pending'
require_relative './status/running'
require_relative './status/passed'
require_relative './status/failed'
require_relative './status/errored'
require_relative './status/aborted'
require_relative './status/passed_with_warnings'
require_relative './status/manual_evaluation_pending'

module Mumuki::Laboratory::Status
  STATUSES = [Pending, Running, Passed, Failed, Errored, Aborted, PassedWithWarnings, ManualEvaluationPending]
end
