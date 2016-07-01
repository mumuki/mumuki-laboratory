class Mumukit::Auth::LoginMethods

  class << self

    def facebook
      'facebook'
    end

    def github
      'github'
    end

    def twitter
      'twitter'
    end

    def google
      'google-oauth2'
    end

    def user_pass
      'Username-Password-Authentication'
    end

    def defaults
      [facebook, github, google, twitter, user_pass]
    end

  end

  def initialize(methods)
    @methods = methods
  end

  def has_few_methods?
    !(user_pass? && social_methods > 1)
  end

  private

  def user_pass?
    @methods.include? user_pass
  end

  def user_pass
    self.class.user_pass
  end

  def social_methods
    (@methods - [user_pass]).size
  end

end
