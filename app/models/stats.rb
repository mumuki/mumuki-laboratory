
class Stats
  include ActiveModel::Model

  attr_accessor :passed, :passed_with_warnings, :failed, :unknown

  def done?
    failed + unknown == 0
  end

  def started?
    failed + passed + passed_with_warnings > 0
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
end
