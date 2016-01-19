class Chapter < ActiveRecord::Base
  include WithLocale
  include WithChapterGuides
  include WithStats
  include FriendlyName
  include Navigable

  has_many :exercises, through: :guides

  default_scope -> { order(:number) }

  validates_presence_of :name, :description

  markdown_on :description, :long_description, :links


  def friendly
    name
  end

  def guides=(guides)
    self.chapter_guides = guides.each_with_index.map do |it, index|
      it.positionate! self, index+1
    end
  end

  def rebuild!(guides)
    transaction do
      chapter_guides.delete_all
      self.guides = guides
      save!
    end
  end
end
