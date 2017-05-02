Mumukit::Auth.configure do |c|
  # We are not using tokens, so implementing this strategy is meaningless
  c.persistence_strategy = nil
end
