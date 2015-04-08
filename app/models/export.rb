class Export < ActiveRecord::Base
  extend WithAsyncAction

  include WithStatus
  include WithGitGuide

  belongs_to :guide
  belongs_to :committer, class_name: 'User'

  schedule_on_create ExportGuideJob

  validates_presence_of :committer

  def run_export!
    run_update! do
      ensure_repo_exists!
      with_cloned_repo 'export' do |dir, repo|
        create_guide_files dir
        repo.commit_all("Mumuki Export on #{Time.now}")
        repo.push
      end
    end
  end

  def create_guide_files(dir)
    # code here
  end


  def ensure_repo_exists!
    create_repo unless git_exists?
  end

  def create_repo
    client = Octokit::Client.new(access_token: committer.token)
    client.create_repository(guide.github_repository)
  end
end
