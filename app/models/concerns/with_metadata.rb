module WithMetadata
  extend ActiveSupport::Concern

  included do
    serialize :metadata, Mumukit::Auth::Metadata

    validates_presence_of :metadata

    [:student?, :teacher?, :admin?].each do |selector|
      define_method(selector) do |organization = Organization.current|
        metadata.send selector, organization.name
      end
    end
  end

  def accessible_organizations
    metadata.accessible_organizations.map {|org| Organization.find_by(name: org)}.compact
  end

  def has_accessible_organizations?
    accessible_organizations.present?
  end
end
