class Comment < ActiveRecord::Base

  self.inheritance_column = :_type_disabled

  belongs_to :assignment, foreign_key: :submission_id
  belongs_to :exercise

  validates_presence_of :exercise_id, :submission_id, :type, :content, :author, :date

  def mark_as_readed
    self.readed = true
    save!
  end

end
