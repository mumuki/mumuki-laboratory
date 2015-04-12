module WithGitGuide

  def with_cloned_repo(key)
    Dir.mktmpdir("mumuki.#{id}.#{key}") do |dir|
      repo = git_clone_into dir
      yield dir, repo
    end
  end

  private

  def git_clone_into(dir)
    Git.clone(github_url, '.', path: dir)
  rescue Git::GitExecuteError => e
    raise 'Repository is private or does not exist' if private_repo_error(e.message)
    raise e
  end

  def git_exists?
    Git.ls_remote(github_url)
    true
  rescue Git::GitExecuteError
    false
  end

  private

  def github_url
    guide.github_authorized_url(committer)
  end

  def private_repo_error(message)
    ['could not read Username', 'Invalid username or password'].any? { |it| message.include? it }
  end
end
