class Message < ActiveRecord::Base

  self.inheritance_column = :_type_disabled

  belongs_to :exercise

  validates_presence_of :exercise_id, :submission_id, :content, :sender

  markdown_on :content

  def self.parse_json(json)
    message = json.delete 'message'
    json
      .except('uid')
      .merge(message)
  end

  def self.create_and_notify!(data)
    message = new data
    message.save!
    message.assignment.has_messages!
    message.notify!
  end

  def self.read_all
    update_all read: true
  end

  def notify!
    Mumukit::Nuntius.notify! 'student-messages', json_to_notify
  end

  def json_to_notify
    as_json(except: [:id, :exercise_id, :type], include: {exercise: {only: [:bibliotheca_id]}}).merge(organization: Organization.current.name)
  end

  def read!
    update! read: true
  end

  def assignment
    Assignment.find_by(submission_id: submission_id)
  end

  def exercise
    assignment.exercise
  end

  def self.import_from_json!(json)
    message_data = Message.parse_json json
    Organization.find_by!(name: message_data.delete('organization')).switch!
    Assignment
      .find_by(submission_id: message_data.delete('submission_id'))&.message! message_data if message_data['submission_id'].present?
  end
end
