module Status
end

require_relative 'status/base'
require_relative 'status/aborted'
require_relative 'status/errored'
require_relative 'status/failed'
require_relative 'status/passed'
require_relative 'status/passed_with_warnings'
require_relative 'status/pending'
require_relative 'status/running'
require_relative 'status/unknown'

module Status
  STATUSES = [Pending, Running, Passed, Failed, Errored, Aborted, PassedWithWarnings]

  def self.load(i)
    STATUSES[i]
  end

  def self.dump(status)
    if status.is_a? Symbol
      from_sym(status).to_i
    else
      status.to_i
    end
  end

  def self.from_sym(status)
    Kernel.const_get("Status::#{status.to_s.camelize}")
  end
end
