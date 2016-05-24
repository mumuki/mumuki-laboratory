require 'mumukit/auth'

class Mumukit::Auth::Token
  def self.from_env(env)
    new(env['omniauth.auth']['extra']['raw_info'])
  end
end
