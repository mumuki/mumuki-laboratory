module Assistable
  extend ActiveSupport::Concern

  included do
    serialize :assistance_rules, Array
    validate :ensure_assistance_rules_format
  end

  def assistant
    Mumukit::Assistant.parse(assistance_rules)
  end

  def assist_with(assignment)
    # not strictly necessary, but avoid going through
    # all the assistence process when there are no rules
    assistance_rules.blank? ? [] : assistant.assist_with(assignment)
  end

  private

  def ensure_assistance_rules_format
    errors.add :assistance_rules,
               :invalid_format unless Mumukit::Assistant.valid? assistance_rules.to_a
  end
end
