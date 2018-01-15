class Usage < ApplicationRecord
  belongs_to :organization

  belongs_to :item, polymorphic: true
  belongs_to :parent_item, polymorphic: true

  scope :in_organization, ->(organization = Organization.current) { where(organization_id: organization.id) }

  before_save :set_slug

  def self.destroy_usages_for(record)
    Usage.where(parent_item: record).destroy_all
  end

  private

  def set_slug
    self.slug = item.slug
  end
end
