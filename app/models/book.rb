class Book < ActiveRecord::Base
  validates_presence_of :name, :locale

  include WithSlug

  numbered :chapters
  aggregate_of :chapters

  has_many :chapters, -> { order(number: :asc) }, dependent:  :delete_all
  has_many :complements, dependent:  :delete_all

  markdown_on :description

  include ChildrenNavigation

  def navigable_name
    name
  end

  def usage_in_organization
    self
  end

  def first_chapter
    chapters.first
  end

  def import_from_json!(json)
    self.assign_attributes json.except('chapters', 'id')
    rebuild! json['chapters'].map { |it| Topic.find_by(slug: it).to_chapter }
  end
end
