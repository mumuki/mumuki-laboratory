module Mumuki::Laboratory::Status::Discussion
  include Mumuki::Laboratory::Status

  require_relative './opened'
  require_relative './closed'
  require_relative './solved'

  STATUSES = [Opened, Closed, Solved]

  def closed?
    false
  end

  def opened?
    false
  end

  def solved?
    false
  end

  def allowed_for?(*)
    true
  end

  def allowed_statuses_for(user, discussion)
    STATUSES.select { |it| it.allowed_for?(user, discussion) }
  end
end
