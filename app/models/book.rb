class Book < ActiveRecord::Base
  validates_presence_of :name, :locale

  include WithSlug, WithTerminalName

  numbered :chapters
  aggregate_of :chapters

  has_many :chapters, -> { order(number: :asc) }, dependent: :delete_all
  has_many :complements, dependent: :delete_all

  markdown_on :description

  include ChildrenNavigation

  def usage_in_organization
    self
  end

  def first_chapter
    chapters.first
  end

  def import_from_json!(json)
    self.assign_attributes json.except('chapters', 'id', 'description')
    self.description = json['description'].squeeze(' ')
    rebuild! json['chapters'].map { |it| Topic.find_by!(slug: it).as_chapter_of(self) }
    Organization.all.each { |org| org.reindex_usages! }
  end

  def index_usages!(organization)
    chapters.each do |chapter|
      organization.index_usage! chapter.topic, chapter
      chapter.topic.index_usages! organization
    end
    complements.each do |complement|
      organization.index_usage! complement.guide, complement
    end
  end
end
