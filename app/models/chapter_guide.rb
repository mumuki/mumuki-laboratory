class ChapterGuide < ActiveRecord::Base
  validates_presence_of :guide, :number, :chapter

  belongs_to :guide
  belongs_to :chapter

  delegate :name, :description_html, :exercises, to: :guide

end
