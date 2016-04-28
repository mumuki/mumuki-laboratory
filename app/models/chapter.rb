class Chapter < ActiveRecord::Base
  include WithLocale
  include WithStats
  include FriendlyName

  belongs_to :book
  belongs_to :topic

  include SiblingsNavigation, ChildrenNavigation

  default_scope -> { order(:number) }

  validates_presence_of :name, :description

  markdown_on :description, :long_description, :links

  delegate :lessons, :pending_guides, :first_guide, :guides, :exercises, to: :topic

  def friendly
    name
  end

  def guides=(guides)
    self.topic.lessons = guides.each_with_index.map do |it, index|
      it.positionate! self, index+1
    end
  end

  def rebuild!(guides)
    transaction do
      lessons.delete_all
      self.guides = guides
      save!
    end
  end
end
