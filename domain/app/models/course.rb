class Course < ApplicationRecord
  include Mumukit::Platform::Course::Helpers

  validates_presence_of :slug, :shifts, :code, :days, :period, :description, :organization_id
  validates_uniqueness_of :slug
  belongs_to :organization

  def self.import_from_resource_h!(resource_h)
    json = Mumukit::Platform::Course::Helpers.slice_platform_json resource_h
    where(slug: json[:slug]).update_or_create!(json)
  end

  def slug=(slug)
    s = Mumukit::Auth::Slug.parse(slug)

    self[:slug] = slug
    self[:code] = s.course
    self[:organization_id] = Organization.find_by!(name: s.organization).id
  end
end
