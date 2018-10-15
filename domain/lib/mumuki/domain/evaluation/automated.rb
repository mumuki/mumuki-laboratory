class Mumuki::Domain::Evaluation::Automated
  def evaluate!(assignment, submission)
    submission.evaluate! assignment
  end
end
