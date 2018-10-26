module WithExpectations
  extend ActiveSupport::Concern

  included do
    serialize :expectations, Array
    validate :ensure_expectations_format
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

  def own_expectations
    self[:expectations]
  end

  def ensure_expectations_format
    errors.add :own_expectations,
               :invalid_format unless own_expectations.to_a.all? { |it| Mumukit::Expectation.valid? it }
  end
end
