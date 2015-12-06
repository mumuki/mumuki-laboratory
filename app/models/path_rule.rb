class PathRule < ActiveRecord::Base
  validates_presence_of :guide, :position, :path

  belongs_to :guide
  belongs_to :path

end
