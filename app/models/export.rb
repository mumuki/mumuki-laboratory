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
        write_guide! dir
        repo.add(all: true)
        repo.commit("Mumuki Export on #{Time.now}")
        repo.push
      end
    end
  end

  def ensure_repo_exists!
    create_repo! unless git_exists?
  end

  def create_repo!
    Rails.logger.info "Creating repository #{guide.github_repository}"
    committer.octokit.create_repository(guide.github_repository_name)
  end

  def write_guide!(dir)
    guide.exercises.each do |e|
      write_exercise! dir, e
    end
    write_description! dir
    write_meta! dir
  end

  def write_exercise!(dir, e)
    Rails.logger.info "Exporting exercise #{e.title} of guide #{guide.name}"

    e.generate_original_id!

    dirname = File.join dir, "#{guide.format_original_id(e)}_#{e.title}"

    Dir.mkdir dirname

    write_file!(dirname, format_extension('test'), e.test)
    write_file!(dirname, 'description.md', e.description)
    write_file!(dirname, 'meta.yml', metadata_yaml(e))

    write_file!(dirname, 'hint.md', e.hint) if e.hint
    write_file!(dirname, format_extension('extra'), e.extra_code) if e.extra_code
    write_file!(dirname, 'expectations.yml', expectations_yaml(e)) if e.expectations.present?
  end

  def write_description!(dir)
    write_file! dir, 'description.md', guide.description
  end

  def write_meta!(dir)
    write_file! dir, 'meta.yml', {
        'locale' => guide.locale,
        'language' => guide.language.name,
        'original_id_format' => guide.original_id_format,
        'order' => guide.exercises.pluck(:original_id)
    }.to_yaml
  end

  private

  def metadata_yaml(e)
    {'tags' => e.tag_list.to_a, 'locale' => e.locale}.to_yaml
  end

  def expectations_yaml(e)
    {'expectations' => e.expectations.as_json(only: [:binding, :inspection])}.to_yaml
  end

  def format_extension(filename)
    "#{filename}.#{guide.language.extension}"
  end

  def write_file!(dirname, name, content)
    File.write(File.join(dirname, name), content)
  end


end
