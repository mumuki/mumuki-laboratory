module WithExpectations
  extend ActiveSupport::Concern

  included do
    serialize :expectations
  end

  def expectations_yaml
    self.expectations.to_yaml
  end

  def expectations_yaml=(yaml)
    self.expectations = YAML.load yaml
  end

  def expectations=(expectations)
    self[:expectations] = expectations.map(&:stringify_keys)
  end

  def expectations
    self[:expectations] || []
  end
end
