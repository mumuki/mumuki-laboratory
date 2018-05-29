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

  def reachable_statuses
    []
  end
end
