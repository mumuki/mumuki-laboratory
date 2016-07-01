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

    def auth0
      'Username-Password-Authentication'
    end

    def defaults
      [facebook, github, google, twitter, auth0]
    end

  end

end
