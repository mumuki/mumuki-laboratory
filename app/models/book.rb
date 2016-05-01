class Book < ActiveRecord::Base
  validates_presence_of :name, :locale

  has_many :chapters
  has_many :complements

  markdown_on :preface

  numbered :chapters

  def rebuild!(chapters)
    transaction do
      self.chapters.delete_all
      self.chapters = chapters
      save!
    end
  end
end
