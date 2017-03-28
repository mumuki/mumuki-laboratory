class Comment < ActiveRecord::Base

  self.inheritance_column = :_type_disabled

  belongs_to :exercise

  validates_presence_of :exercise_id, :submission_id, :content, :author

  markdown_on :content

  def self.parse_json(json)
    message = json.delete :message
    message[:author] = message.delete :sender
    json
      .except(:uid)
      .merge(message)
  end

  def read!
    self.read = true
    save!
  end

  def assignment
    Assignment.find_by(submission_id: submission_id)
  end

  def exercise
    assignment.exercise
  end

  def self.import_from_json!(json)
    message_data = Comment.parse_json json
    Organization.find_by!(name: message_data.delete(:tenant)).switch!
    Comment.create! message_data if message_data[:submission_id].present?
  end
end
