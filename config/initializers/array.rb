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

class Array
  def merge_numbers!(key=:number)
    self.each_with_index do |r, i|
      r.send "#{key}=", i+1
    end
  end
end