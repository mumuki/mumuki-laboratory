class Exercise < ActiveRecord::Base
  enum language: [:haskell, :prolog]

  has_many :submissions

  validates_presence_of :title, :description
end
