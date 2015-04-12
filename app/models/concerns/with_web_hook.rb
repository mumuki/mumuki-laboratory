module WithWebHook
  def register_post_commit_hook!(web_hook)
    author.octokit.create_hook(
        github_repository, 'web',
        {url: web_hook, content_type: 'json'},
        {events: ['push'],
         active: true})
  end
end
