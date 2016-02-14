class BookBuilder
  def initialize
    @chapters=[]
    @preface = ''
    @locale = 'en'
  end

  def locale(locale)
    @locale = locale
  end

  def preface(preface)
    @preface = preface.squeeze(' ')
  end

  def chapter(name)
    builder = ChapterBuilder.new(name)
    yield builder
    @chapters << builder.build
  end

  def build!
    book = Book.current
    book.preface = @preface
    book.locale = @locale
    book.rebuild! @chapters
  end

  def self.build!
    book = BookBuilder.new
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
    @description = description.squeeze(' ')
  end

  def build
    @chapter.guides = @slugs.map do |it|
      guide = Guide.find_by(slug: it)
      raise "Guide #{it} not found!" unless guide
      guide
    end
    @chapter.locale = @locale
    @chapter.description = @description
    @chapter
  end

  private

  def create_slug(slug_part)
    if slug_part.include? '/'
      slug_part
    else
      "#{@organization}/mumuki-#{I18n.transliterate(I18n.t :guide_internal).downcase}-#{@prefix}-#{slug_part}"
    end
  end
end


