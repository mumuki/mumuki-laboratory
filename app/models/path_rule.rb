class PathRule < ActiveRecord::Base
  include WithSlug

  validates_presence_of :guide, :position, :path

  belongs_to :guide
  belongs_to :path

  def name_changed?
    path_id_changed? || guide_id_changed?
  end

  def slugged_name
    guide.slugged_name
  end
end
