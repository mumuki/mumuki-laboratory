class Chapter < ActiveRecord::Base
  include WithLocale
  include WithMarkup
  include WithChapterGuides
  include WithStats

  validates_presence_of :name, :description

  markup_on :description, :long_description, :links

  has_many :exercises, through: :guides

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

  def self.rebuild!(chapters)
    transaction do
      delete_all
      chapters.each_with_index do |it, index|
        it.number = index + 1
        it.save!
      end
    end
  end
end
