module MailerHelper
  def delete_account_url_for(user)
    @organization.url_for("/user/delete_confirmation?token=#{user.delete_account_token}")
  end
end
