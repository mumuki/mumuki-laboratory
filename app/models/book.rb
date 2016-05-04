class Book < ActiveRecord::Base
  validates_presence_of :name, :locale

  numbered :chapters
  aggregate_of :chapters

  has_many :chapters, -> { order(number: :asc) }, dependent:  :delete_all
  has_many :complements, dependent:  :delete_all

  markdown_on :preface

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
end
