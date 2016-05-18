class ExamAuthorization < ActiveRecord::Base

  belongs_to :user
  belongs_to :exam

  def start!
    update_attribute(:started, true)
  end

end
