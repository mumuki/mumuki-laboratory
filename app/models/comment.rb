class Comment < ActiveRecord::Base

  self.inheritance_column = :_type_disabled

  belongs_to :exercise

  validates_presence_of :exercise_id, :submission_id, :type, :content, :author, :date

  def self.parse_json(comment_json)
    comment = comment_json.delete('comment')
    comment['author'] = comment.delete('email')
    comment_json.merge(comment)
  end

  def read!
    self.read = true
    save!
  end

  def assignment
    Assignment.find_by(submission_id: submission_id)
  end

end
