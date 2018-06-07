module Assistable
  extend ActiveSupport::Concern

  included do
    serialize :assistance_rules, Array
  end

  def assistant
    Mumukit::Assistant.parse(assistance_rules)
  end

  def assist_with(assignment)
    # not strictly necessary, but avoid going through
    # all the assistence process when there are no rules
    assistance_rules.blank? ? [] : assistant.assist_with(assignment)
  end
end
