class Topic < ActiveRecord::Base
  include WithLocale

  validates_presence_of :name, :description

  has_many :chapters
  has_many :lessons, -> { order(number: :asc) }

  has_many :guides, -> { order('lessons.number') }, through: :lessons
  has_many :exercises, through: :guides

  include TopicNavigation

  markdown_on :description, :long_description, :links

  numbered :lessons

  def rebuild!(lessons)
    transaction do
      self.lessons.delete_all
      self.lessons = lessons
      save!
    end
  end

  has_many :usages, as: :item

end
