class Organization < ActiveRecord::Base
  belongs_to :book

  delegate :locale, to: :book

  validates_presence_of :name, :contact_email
  validates_uniqueness_of :name

  def switch!
    self.class.current = self
  end

  def central?
    name == 'central'
  end

  def test?
    name == 'test'
  end

  def silent?
    central? || test?
  end

  class << self
    attr_writer :current

    def current
      raise 'book not selected' unless @current
      @current
    end

    def central
      find_by name: 'central'
    end

    def central?
      current.central?
    end
  end

end
