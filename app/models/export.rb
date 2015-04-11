class Export < ActiveRecord::Base
  extend WithAsyncAction

  include WithStatus
  include WithGitGuide

  belongs_to :guide
  belongs_to :committer, class_name: 'User'

  schedule_on_create ExportGuideJob

  validates_presence_of :committer

  def run_export!
    Rails.logger.info "Exporting guide #{guide.name}"
    run_update! do
      ensure_repo_exists!
      with_cloned_repo 'export' do |dir, repo|
        create_guide_files dir
        repo.add(all: true)
        repo.commit("Mumuki Export on #{Time.now}")
        repo.push
      end
    end
  end

  def create_guide_files(dir)
    write_file dir, 'description.md', guide.description
    guide.exercises.each do |e|
      Rails.logger.info "Exporting exercise #{e.title} of guide #{guide.title}"
      dirname = File.join dir, "#{'%05d' % e.original_id}_#{e.title}"
      Dir.mkdir dirname
      write_file(dirname, format_extension('test'), e.test)
      write_file(dirname, 'description.md', e.description)
      write_file(dirname, 'meta.yml', '')

      write_file(dirname, 'hint.md', e.hint) if e.hint
      write_file(dirname, format_extension('extra'), e.extra_code) if e.extra_code
      write_file(dirname, 'expectations.yml', '') if e.expectations.present?
    end
  end

  def format_extension(filename)
    "#{filename}.#{guide.language.extension}"
  end

  def write_file(dirname, name, content)
    File.write(File.join(dirname, name), content)
  end


  def ensure_repo_exists!
    create_repo unless git_exists?
  end

  def create_repo
    Rails.logger.info "Creating repository #{guide.github_repository}"
    client = Octokit::Client.new(access_token: committer.token)
    client.create_repository(guide.github_repository)
  end
end
