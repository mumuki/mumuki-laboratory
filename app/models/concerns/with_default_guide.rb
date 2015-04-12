module WithDefaultGuide
  extend ActiveSupport::Concern

  included do
    belongs_to :default_guide, class_name: 'Guide'
  end

  def find_or_create_default_guide
    transaction do
      if default_guide.nil?
        self.default_guide = new_default_guide
      end
    end
    self.default_guide
  end

  private

  def new_default_guide
    Guide.create!(
        github_repository: "#{name}/mumuki-default-guide",
        name: name,
        author: self,
        description: "Mumuki Default Guide for user #{name}")
  end
end
