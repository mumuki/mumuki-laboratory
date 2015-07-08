module Status
  module Base
    def to_s
      name.demodulize.underscore
    end

    def to_i
      Status::STATUSES.index(self)
    end

    def to_sym
      to_s.to_sym
    end

    def group
      self
    end

    def passed?
      false
    end

    def self.iconize
      group.iconize
    end
  end

  module Unknown
    extend Base

    def to_i
      raise 'unknown status'
    end

    def self.iconize
      {class: :muted, type: :circle}
    end
  end

  module Pending
    extend Base

    def self.group
      Unknown
    end

    def self.iconize
      {class: :info, type: 'clock-o'}
    end
  end

  module Running
    extend Base

    def self.group
      Unknown
    end

    def self.iconize
      {class: :info, type: :circle}
    end
  end

  module Passed
    extend Base

    def passed?
      true
    end

    def self.iconize
      {class: :success, type: :check}
    end
  end

  module PassedWithWarnings
    extend Base

    def passed?
      true
    end

    def self.iconize
      {class: :warning, type: :exclamation}
    end
  end

  module Failed
    extend Base

    def self.iconize
      {class: :danger, type: :times}
    end
  end

  module Errored
    extend Base

    def self.group
      Failed
    end
  end

  module Aborted
    extend Base

    def self.group
      Failed
    end
  end

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
