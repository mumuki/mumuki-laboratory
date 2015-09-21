class Category < ActiveRecord::Base
  include WithLocale
  include WithMarkup

  has_many :paths

  validates_presence_of :name, :description, :image_url

  markup_on :description, :long_description, :links

  def valid_paths
    paths.select{|it| it.first_guide.present? }
  end

  def single_path?
    self.valid_paths.size <=1
  end

  def single_path
    self.valid_paths.first
  end

  def all_Single_path? #even the ones that are invalid
    self.paths.size <=1
  end
end
