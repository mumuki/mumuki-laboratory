class Path < ActiveRecord::Base
  include WithGuides

  belongs_to :category
  belongs_to :language
end
