class SubmissionFileset
  include ActiveModel::Model

  attr_accessor :fileset

  def normalize_whitespaces
    fileset.each {|_k, v| v[:content] = v[:content].normalize_whitespaces}
    self
  end

  def as_json(*)
    fileset
  end

end
