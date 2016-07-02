class Mumukit::Auth::LoginSettings

  attr_accessor :login_methods

  def to_lock_json(callback_url, options={})
    {dict: I18n.locale,
     connections: login_methods,
     icon: '/logo-alt.png',
     socialBigButtons: has_few_methods?,
     callbackURL: callback_url,
     responseType: 'code',
     authParams: {scope: 'openid profile'},
     disableResetAction: false}
    .merge(options)
    .to_json
  end

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
