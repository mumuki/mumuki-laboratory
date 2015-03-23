class Guide < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name, :description],
  }

  include WithSearch
  include WithAuthor

  #TODO rename name to title. This helps building also generic link_to compoenetns
  has_many :exercises
  has_many :imports

  validates_presence_of :github_repository, :name, :author, :description
  validate :valid_name?

  def valid_name?
    errors.add(:name, 'can not contain whitespaces') if name && name =~ /\s+/
  end

  def exercises_count
    exercises.count
  end

  def language
    exercises.first.language
  end

  def search_tags
    exercises.flat_map(&:search_tags).uniq
  end

  def github_url
    "https://github.com/#{github_repository}"
  end
end
