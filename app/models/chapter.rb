class Chapter < ActiveRecord::Base
  include WithLocale
  include WithMarkup
  include WithChapterGuides
  include WithStats

  validates_presence_of :name, :description

  markup_on :description, :long_description, :links

  has_many :exercises, through: :guides

  def slugged_name
    name
  end

  def rebuild!(guides)
    transaction do
      chapter_guides.delete_all
      chapter_guides = guides.each_with_index.map do |it, index|
        it.positionate! self, index+1
      end
      update chapter_guides: chapter_guides
    end
  end
end
