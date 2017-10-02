class Step < PersistentSubmission
  attr_accessor :value

  def content
    value
  end

  def try_evaluate_against!(assignment)
    assignment.seek_goal!(steps: content.split("\n")).except(:response_type)
  end
end
