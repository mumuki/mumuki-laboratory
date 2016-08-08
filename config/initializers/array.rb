class Array
  def with_pagination
    Kaminari.paginate_array(self)
  end
end

class Kaminari::PaginatableArray
  def with_pagination
    self
  end
end
