class Comment < ActiveRecord::Base

  self.inheritance_column = :_type_disabled

  belongs_to :assignment, foreign_key: :submission_id
  belongs_to :exercise

  validates_presence_of :exercise_id, :submission_id, :type, :content, :author, :date

  def self.parse_json(comment_json)
    comment = comment_json.delete('comment')
    comment['author'] = comment.delete('email')
    comment_json.merge(comment)
  end

  def mark_as_readed
    self.readed = true
    save!
  end


end
