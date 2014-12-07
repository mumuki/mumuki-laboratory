class Exercise < ActiveRecord::Base
  LANGUAGES = [:haskell, :prolog]

  enum language: LANGUAGES

  has_many :submissions

  validates_presence_of :title, :description, :language, :test

  def plugin
    Kernel.const_get("#{language.to_s.titleize}Plugin".to_sym).new
  end
end
