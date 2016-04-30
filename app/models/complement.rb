class Complement < ActiveRecord::Base
  belongs_to :guide
  belongs_to :book
end
