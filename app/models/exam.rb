class Exam < ActiveRecord::Base
  validates_presence_of :duration, :guide, :start_time, :end_time

  belongs_to :guide
  belongs_to :organization

  has_and_belongs_to_many :users

  def enabled?
    enabled_range.cover? DateTime.now
  end

  def accesible_by?(user)
    enabled? && authorized?(user)
  end

  def authorize!(user)
    users << user
  end

  def authorized?(user)
    users.include? user
  end

  def enabled_range
    start_time..end_time
  end
end
