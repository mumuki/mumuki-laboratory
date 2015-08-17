class Stats
  include ActiveModel::Model

  attr_accessor :passed, :passed_with_warnings, :failed, :unknown

  def total
    submitted + unknown
  end

  def submitted
    failed + resolved
  end

  def pending
    failed + unknown
  end

  def resolved
    passed + passed_with_warnings
  end

  def done?
    pending == 0
  end

  def good_progress?
    resolved * 1.3 > failed
  end

  def stuck?
    failed * 1.3 > resolved
  end

  def started?
    submitted > 0
  end

  def resolved_ratio
    ratio resolved
  end

  def passed_ratio
    ratio passed
  end

  def passed_with_warnings_ratio
    ratio passed_with_warnings
  end

  def failed_ratio
    ratio failed
  end

  def to_h(&key)
    {key.call(:passed) => passed,
     key.call(:passed_with_warnings) => passed_with_warnings,
     key.call(:failed) => failed,
     key.call(:unknown) => unknown}
  end

  def self.from_statuses(statuses)
    Stats.new(statuses.inject({passed: 0, passed_with_warnings: 0, failed: 0, unknown: 0}) do |accum, status|
      accum[status.group.to_sym] += 1
      accum
    end)
  end

  private

  def ratio(x)
    (100 * x / total.to_f).round(2)
  end
end
