class Guide < ActiveRecord::Base
  belongs_to :author, class_name: 'User'

  has_many :exercises
  has_many :imports

  validates_presence_of :github_repository, :name, :author

  def github_url
    "https://github.com/#{github_repository}"
  end
end
