module WithOctokit
  def octokit
    Octokit::Client.new(access_token: token)
  end
end
