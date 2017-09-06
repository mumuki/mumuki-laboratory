class Unit < Container
  belongs_to :organization
  belongs_to :book

  has_many :projects, dependent: :delete_all
  has_many :complements, dependent: :delete_all

  delegate :chapters, to: :book

  include TerminalNavigation

  def index_usage!
    [book.chapters, projects, complements].flatten.each { |item| item.index_usage_at! organization }
  end

  def child
    book
  end

end
