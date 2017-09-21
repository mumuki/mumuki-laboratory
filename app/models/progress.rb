class Progress < ActiveRecord::Base
  include WithStatus

  belongs_to :user
  belongs_to :item, polymorphic: true
end


