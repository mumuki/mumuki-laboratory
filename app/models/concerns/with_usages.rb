module WithUsages
  extend ActiveSupport::Concern

  included do
    has_many :usages, as: :item
  end

  def usage_in_organization(organization = Organization.current)
    usages.in_organization(organization).first.try(:parent_item)
  end
end