class Question < Solution

  def content
    ''
  end

  def try_evaluate_against!(*)
    {status: :pending, result: ''}
  end
end
