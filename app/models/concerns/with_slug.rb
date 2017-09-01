#TODO may use mumukit slug
module WithSlug
  extend ActiveSupport::Concern

  included do
    validates_presence_of :slug
    validates_uniqueness_of :slug
  end

  def import!
    import_from_json! Mumukit::Bridge::Bibliotheca.new(Mumukit::Platform.bibliotheca_api.url).send(self.class.name.underscore, slug)
  end

  def slug_parts
    org, repo = slug.split('/')
    {organization: org, repository: repo}
  end

  module ClassMethods
    def import!(slug)
      prepare_by(slug: slug) { |it| it.import! }
    end

    def by_slug_parts!(args)
      find_by!(slug: "#{args[:organization]}/#{args[:repository]}")
    end
  end
end
