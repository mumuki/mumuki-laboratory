class Usage < ActiveRecord::Base
  belongs_to :organization

  belongs_to :item, polymorphic: true
  belongs_to :parent_item, polymorphic: true

  scope :in_organization, ->(organization = Organization.current) { where(organization_id: organization.id) }

  before_save :set_slug

  private

  def set_slug
    self.slug = item.slug
  end
end
