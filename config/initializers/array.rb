class Array
  def with_pagination
    Kaminari.paginate_array(self)
  end

  def insert_last(element)
    self + [element]
  end
end

class NilClass
  def insert_last(element)
    [element]
  end
end

class Kaminari::PaginatableArray
  def with_pagination
    self
  end
end
