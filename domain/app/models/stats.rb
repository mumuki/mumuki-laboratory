class Stats
  include ActiveModel::Model

  attr_accessor :passed, :passed_with_warnings, :failed, :pending

  def submitted
    passed + passed_with_warnings + failed
  end

  def done?
    failed + pending == 0
  end

  def started?
    submitted > 0
  end

  def self.from_statuses(statuses)
    Stats.new(statuses.inject({passed: 0, passed_with_warnings: 0, failed: 0, pending: 0}) do |accum, status|
      accum[status.group.to_sym] += 1
      accum
    end)
  end
end
