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
