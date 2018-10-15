class QueriableChallenge < Challenge
  include Queriable

  delegate :stateful_console?, to: :language
end
