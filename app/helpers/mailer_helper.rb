module MailerHelper
  def delete_account_url_for(user)
    delete_user_url host: organic_domain_for(user), token: user.delete_account_token
  end

  private

  def organic_domain_for(user)
    Mumukit::Platform.laboratory.organic_domain(user.last_organization)
  end
end
