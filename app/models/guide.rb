class Guide < ActiveRecord::Base
  include WithAuthor

  belongs_to :author, class_name: 'User'

  #TODO rename name to title. This helps building also generic link_to compoenetns
  has_many :exercises
  has_many :imports

  validates_presence_of :github_repository, :name, :author

  def github_url
    "https://github.com/#{github_repository}"
  end
end
