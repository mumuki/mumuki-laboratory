class ChapterGuide < ActiveRecord::Base
  validates_presence_of :guide, :position, :chapter

  belongs_to :guide
  belongs_to :chapter

end
