class ActiveRecord::Base
  def self.all_except(others)
    where.not(id: [others.map(&:id)])
  end
end