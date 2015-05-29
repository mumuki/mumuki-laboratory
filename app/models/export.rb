class Export < ActiveRecord::Base
  extend WithAsyncAction

  include WithStatus

  belongs_to :guide
  belongs_to :committer, class_name: 'User'

  schedule_on_create ExportGuideJob

  validates_presence_of :committer

  delegate :language, to: :guide

  def run_export!
    Rails.logger.info "Exporting guide #{guide.id}"
    run_update! do
      committer.ensure_repo_exists! guide
      committer.with_cloned_repo guide, 'export' do |dir, repo|
        write_guide! dir
        repo.add(all: true)
        repo.commit("Mumuki Export on #{Time.now}")
        repo.push
      end
      {result: 'Exported', status: :passed} #TODO save sha
    end
  end

  def write_guide!(dir)
    guide.exercises.each do |e|
      write_exercise! dir, e
    end
    write_description! dir
    write_corollary! dir
    write_meta! dir
  end

  def write_exercise!(dir, e)
    Rails.logger.info "Exporting exercise #{e.title} of guide #{guide.id}"

    e.generate_original_id!

    dirname = File.join dir, "#{guide.format_original_id(e)}_#{e.title}"

    FileUtils.mkdir_p dirname

    write_file!(dirname, "test.#{language.test_extension}", e.test)
    write_file!(dirname, 'description.md', e.description)
    write_file!(dirname, 'meta.yml', metadata_yaml(e))

    write_file!(dirname, 'hint.md', e.hint) if e.hint.present?
    write_file!(dirname, "extra.#{language.extension}", e.extra_code) if e.extra_code.present?
    write_file!(dirname, 'expectations.yml', expectations_yaml(e)) if e.expectations.present?
  end

  def write_description!(dir)
    write_file! dir, 'description.md', guide.description
  end

  def write_corollary!(dir)
    write_file! dir, 'corollary.md', guide.corollary if guide.corollary
  end

  def write_meta!(dir)
    write_file! dir, 'meta.yml', {
        'locale' => guide.locale,
        'language' => language.name,
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


  def write_file!(dirname, name, content)
    File.write(File.join(dirname, name), content)
  end


end
