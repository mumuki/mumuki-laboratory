#TODO may use mumukit slug
module WithSlug
  extend ActiveSupport::Concern

  included do
    validates_presence_of :slug
    validates_uniqueness_of :slug
  end

  def slug_parts
    org, repo = slug.split('/')
    {organization: org, repository: repo}
  end

  ## Resource Protocol

  def sync_key
    Mumukit::Sync.key self.class, slug
  end

  ## Copy and Rebase

  def rebase!(organization)
    self.slug = self.slug.to_mumukit_slug.rebase(organization).to_s
  end

  def rebased_dup(organization)
    dup.tap { |it| it.rebase! organization }
  end

  ## Filtering

  module ClassMethods

    def allowed(permissions)
      all.select { |it| permissions&.writer?(it.slug) }
    end

    def visible(permissions)
      # FIXME no truly generic
      all.select { |it| !it.private? || permissions&.writer?(it.slug) }
    end

    def by_slug_parts!(args)
      find_by!(slug: "#{args[:organization]}/#{args[:repository]}")
    end

    def locate_resource(key)
      find_or_initialize_by(slug: key)
    end
  end
end
