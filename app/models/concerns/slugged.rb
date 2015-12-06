module Slugged

  def to_param
    slug
  end

  def slug
    "#{id} #{slugged_name}".sluggish
  end
end