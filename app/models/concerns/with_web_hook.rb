module WithWebHook
  def web_hook
    Rails.application.routes.url_helpers.guide_imports_url(self)
  end

  def register_post_commit_hook!
    author.octokit.create_hook(
        github_repository, 'web',
        {url: web_hook, content_type: 'json'},
        {events: ['push'],
         active: true})
  end
end
