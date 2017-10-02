module Seekable
  def submit_step!(user, attributes={})
    submit! user, Step.new(attributes)
  end

  def seek_goal!(params)
    language.seek_goal! params.merge(extra: extra, locale: locale, goal: goal)
  end
end
