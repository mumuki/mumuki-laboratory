class Export < ActiveRecord::Base
  extend WithAsyncAction

  include WithStatus
  include WithGitGuide

  belongs_to :guide

  schedule_on_create ExportGuideJob

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
    #TODO
  end
end
