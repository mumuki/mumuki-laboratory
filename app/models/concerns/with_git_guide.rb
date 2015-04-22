module WithGitGuide

  def with_cloned_repo(key)
    Dir.mktmpdir("mumuki.#{id}.#{key}") do |dir|
      repo = clone_repo_into dir
      yield dir, repo
    end
  end

  def create_repo!
    Rails.logger.info "Creating repository #{guide.github_repository}"
    committer.octokit.create_repository(guide.github_repository_name)
  end

  def clone_repo_into(dir)
    Git.clone(repo_github_url, '.', path: dir)
  rescue Git::GitExecuteError => e
    raise 'Repository is private or does not exist' if private_repo_error(e.message)
    raise e
  end

  def repo_exists?
    Git.ls_remote(repo_github_url)
    true
  rescue Git::GitExecuteError
    false
  end

  private

  def repo_github_url
    guide.github_authorized_url(committer)
  end

  def private_repo_error(message)
    ['could not read Username', 'Invalid username or password'].any? { |it| message.include? it }
  end
end
