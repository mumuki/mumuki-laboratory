class Usage < ActiveRecord::Base
  belongs_to :organization

  belongs_to :item, polymorphic: true 
  belongs_to :parent_item, polymorphic: true
end
