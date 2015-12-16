class Book
  def initialize
    @chapters=[]
  end

  def chapter(name)
    builder = ChapterBuilder.new(name)
    yield builder
    @chapters << builder.build
  end

  def build!
    Chapter.rebuild!(@chapters)
  end

  def self.build!
    book = Book.new
    yield book
    book.build!
  end
end

class ChapterBuilder
  def initialize(name)
    @chapter = Chapter.new(name: name)
    @slugs = []
  end

  def organization(name)
    @organization = name
  end

  def prefix(prefix)
    @prefix = prefix
  end

  def guide(slug_part)
    @slugs << create_slug(slug_part)
  end

  def locale(locale)
    @locale = locale
  end

  def description(description)
    @description = description
  end

  def build
    @chapter.guides = @slugs.map do |it|
      guide = Guide.find_by(slug: it)
      raise "Guide #{it} not found!" unless guide
      guide
    end

    @chapter
  end

  private

  def create_slug(slug_part)
    "#{@organization}/mumuki-#{I18n.t :guide}-#{@prefix}-#{slug_part}"
  end
end


