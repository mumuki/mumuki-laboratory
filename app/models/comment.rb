class Comment < ActiveRecord::Base

  self.inheritance_column = :_type_disabled

  belongs_to :exercise
  belongs_to :assignment
  belongs_to :recipient, class_name: 'User'

  validates_presence_of :exercise_id, :submission_id, :type, :content, :author, :date

  markdown_on :content

  def self.parse_json(comment_json)
    assignment = Assignment.find_by!(submission_id: comment['submission_id'])

    comment = comment_json.delete('comment')
    comment['author'] = comment.delete('email')
    comment['assignment_id'] = assignment.id
    comment['recipient_id'] = assignment.submitter.id
    comment_json
      .except('social_id')
      .merge(comment)
  end

  def read!
    self.read = true
    save!
  end

  def latest?
    assignment.submission_id == submission_id
  end

  def self.import_from_json!(json)
    comment_data = Comment.parse_json json

    Organization.find_by!(name: comment_data.delete('tenant')).switch!
    Comment.create! comment_data if comment_data['submission_id'].present?
  rescue
    #useless comment, ignoring it
  end
end
