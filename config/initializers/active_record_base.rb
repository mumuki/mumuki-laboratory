class ActiveRecord::Base
  def self.all_except(others)
    where.not(id: [others.map(&:id)])
  end

  def save(*)
    super
  rescue => e
    self.errors.add :base, e.message
    self
  end

  def self.numbered(*associations)
    associations.each do |it|
      before_validation { send(it).merge_numbers! }
    end
  end
end