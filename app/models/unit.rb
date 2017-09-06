class Unit < ActiveRecord::Base
  include FriendlyName

  validates_presence_of :organization
  validates_presence_of :book

  belongs_to :organization
  belongs_to :book

  has_many :projects, dependent: :delete_all
  has_many :complements, dependent: :delete_all

  include TerminalNavigation

  delegate :name, :description, :description_teaser_html, to: :book

  def index_usage!
    [book.chapters, projects, complements].flatten.each { |item| item.index_usage_at! organization }
  end

end
