class StartingPoint < ActiveRecord::Base
  belongs_to :category
  belongs_to :language
  belongs_to :guide
end
