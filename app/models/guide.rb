class Guide < ActiveRecord::Base
  include Import
  include ExerciseRepositoryLayout

  belongs_to :author, class_name: 'User'

  has_many :exercises

  validates_presence_of :github_repository, :name, :author

  after_commit :schedule_import!

  def github_url
    "https://github.com/#{github_repository}"
  end

end
