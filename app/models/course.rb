class Course < ApplicationRecord
  include Mumukit::Platform::Course::Helpers

  validates_presence_of :slug, :shifts, :code, :days, :period, :description, :organization_id
  validates_uniqueness_of :slug
  belongs_to :organization

  def self.import_from_json!(data)
    where(slug: data[:slug]).update_or_create!(data)
  end

  def slug=(slug)
    self[:slug] = slug
    self[:organization_id] = Organization.find_by(name: Mumukit::Auth::Slug.parse(slug).organization).id
  end

  def organization=(organization)
    self[:organization_id] = organization.id
    self[:slug] = "#{organization.name}/#{code}"
  end
end
