class Comment < ActiveRecord::Base

  self.inheritance_column = :_type_disabled

  belongs_to :assignment, foreign_key: :submission_id
  belongs_to :exercise

  def mark_as_readed
    self.readed = true
    save!
  end

end
