module Seekable
  def submit_step!(user, attributes={})
    submit! user, Step.new(attributes)
  end
end
