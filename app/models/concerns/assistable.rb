module Assistable
  extend ActiveSupport::Concern

  included do
    serialize :tips_rules, Array
  end

  def assistant
    Mumukit::Assistant.new(tips_rules)
  end

  def tips_for(assignment)
    # not strictly necessary, but avoid going through
    # all the assistence process when there are no rules
    tips_rules.blank? ? [] : assistant.assist_with(assignment)
  end
end