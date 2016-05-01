class Topic < ActiveRecord::Base
  include WithLocale

  validates_presence_of :name, :description

  has_many :chapters
  has_many :lessons, -> { order(number: :asc) }

  has_many :guides, -> { order('lessons.number') }, through: :lessons
  has_many :exercises, through: :guides

  include TopicNavigation


end
