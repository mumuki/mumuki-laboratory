class Exercise < ActiveRecord::Base
  LANGUAGES = [:haskell, :prolog]

  enum language: LANGUAGES

  has_many :submissions

  validates_presence_of :title, :description, :language, :test, :submissions_count
  after_initialize :defaults, if: :new_record?

  def plugin
    Kernel.const_get("#{language.to_s.titleize}Plugin".to_sym).new
  end

  private

  def defaults
    self.submissions_count = 0
  end
end
