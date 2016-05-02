class Book < ActiveRecord::Base
  validates_presence_of :name, :locale

  numbered :chapters
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

  def rebuild!(chapters)
    transaction do
      self.chapters.delete_all
      self.chapters = chapters
      save!
    end
  end
end
