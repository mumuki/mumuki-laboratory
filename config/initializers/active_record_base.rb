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

  def self.aggregate_of(association)
    class_eval do
      define_method(:rebuild!) do |children|
        transaction do
          self.send(association).all_except(children).delete_all
          self.update! association => children
          children.each &:save!
        end
        reload
      end
    end
  end

  def self.numbered(*associations)
    class_eval do
      associations.each do |it|
        define_method("#{it}=") do |e|
          e.merge_numbers!
          super(e)
        end
      end
    end
  end
end