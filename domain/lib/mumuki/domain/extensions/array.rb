class Array
  def insert_last(element)
    self + [element]
  end
end

class NilClass
  def insert_last(element)
    [element]
  end
end
