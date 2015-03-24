class Stats
  include ActiveModel::Model

  attr_accessor :passed, :failed, :unknown

  def total
    passed + failed + unknown
  end

  def submitted
    passed + failed
  end

  def pending
    failed + unknown
  end

  def done?
    pending == 0
  end

  def good_progress?
    passed * 1.3 > failed
  end

  def stuck?
    failed * 1.3 > passed
  end

  def to_h(&key)
    [:passed, :failed, :unknown].map { |it| [key.call(it), send(it)] }.to_h
  end

  def self.from_statuses(statuses)
    Stats.new(statuses.inject({passed: 0, failed: 0, unknown: 0}) do |accum, status|
      accum[status] += 1
      accum
    end)
  end
end
