module WithDescription
  extend ActiveSupport::Concern

  included do
    markdown_on :description, :description_teaser
    validates_presence_of :description
  end

  def description_teaser
    description.markdown_paragraphs.first
  end
end
