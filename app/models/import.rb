class Import < RepositoryOperation
  include WithFileReading

  schedule_on_create ImportGuideJob

  def run_import!
    run_update! do
      Rails.logger.info("Importing exercises for #{guide.github_url}")
      log = nil
      with_cloned_repo do |dir|
        log = read_guide! dir
      end
      guide.update_contributors!
      {result: log.to_s, status: :passed}
    end
  end

  def read_guide!(dir)
    order = read_meta! dir
    read_description! dir
    read_corollary! dir
    read_extra! dir
    read_exercises! dir, order
  end

  def read_description!(dir)
    description = read_file(File.join(dir, 'description.md'))
    raise 'Missing description file' unless description
    guide.update!(description: description)
  end

  def read_corollary!(dir)
    guide.update!(corollary: read_file(File.join(dir, 'corollary.md')))
  end

  def read_extra!(dir)
    guide.update!(extra_code: read_code_file(dir, 'extra'))
  end

  def read_meta!(dir)
    meta = read_yaml_file(File.join(dir, 'meta.yml'))

    guide.language = Language.find_by_ignore_case! :name, meta['language']
    guide.locale = meta['locale']
    read_optional! meta, 'original_id_format', '%05d'
    read_optional! meta, 'learning', false
    read_optional! meta, 'beta', false
    guide.save!

    meta['order']
  end

  def read_optional!(meta, key, default)
    guide[key] = meta[key] || default
  end

  def read_exercises!(dir, order = nil)
    ordering = Ordering.from order
    log = ImportLog.new
    GuideReader.new(author, language, dir).read_exercises(log) do |exercise_builder|
      exercise_builder.ordering = ordering
      exercise_builder.guide = guide
      exercise = exercise_builder.build
      exercise.save
      log.saved exercise
    end
    log
  end
end


class ExerciseBuilder < OpenStruct
  def ordering=(ordering)
    ordering.with_position(original_id, self)
  end

  def type
    (meta['type'] || 'problem').camelize
  end

  def clazz
    @clazz ||= Kernel.const_get(type)
  end

  def tag_list
    meta['tags']
  end

  def locale
    meta['locale']
  end

  def layout
    meta['layout'] || Exercise.default_layout
  end

  def expectations_list
    if clazz == Playground
      nil
    else
      (expectations || []).map do |e|
        {binding: e['binding'], inspection: e['inspection']}
      end
    end
  end

  def build
    exercise = clazz.find_or_initialize_by(original_id: original_id, guide_id: guide.id)
    exercise.assign_attributes(
        name: name,
        description: description,
        position: position,
        hint: hint,
        corollary: corollary,
        test: test,
        extra_code: extra_code,
        language: language,
        author: author,
        expectations: expectations_list,
        tag_list: tag_list,
        locale: locale,
        layout: layout)
    exercise
  end
end