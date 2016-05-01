class Topic < ActiveRecord::Base
  include WithLocale

  validates_presence_of :name, :description

  has_many :chapters
end
