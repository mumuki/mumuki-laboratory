class Container < ActiveRecord::Base
  self.abstract_class = true

  include FriendlyName

  delegate :name,
           :description,
           :description_html,
           :description_teaser_html,
           :locale, to: :child

  validates_presence_of :child#, :structural_parent

  def used_in?(organization)
    child.usage_in_organization(organization) == self
  end

  def index_usage_at!(organization)
    organization.index_usage_of! child, self
  end


end
