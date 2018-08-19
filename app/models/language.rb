class Language < ApplicationRecord
  include WithCaseInsensitiveSearch

  enum output_content_type: [:plain, :html, :markdown]

  validates_presence_of :runner_url, :output_content_type

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  markdown_on :description

  delegate :run_tests!, :run_query!, :run_try!, to: :bridge

  def bridge
    Mumukit::Bridge::Runner.new(runner_url)
  end

  def highlight_mode
    self[:highlight_mode] || name
  end

  def output_content_type
    Mumukit::ContentType.for(self[:output_content_type])
  end

  def to_s
    name
  end

  def self.for_name(name)
    find_by_ignore_case!(:name, name) if name
  end

  def import!
    import_from_json! bridge.importable_info
  end

  def devicon
    self[:devicon] || name.downcase
  end

  def import_from_json!(json)

    assign_attributes json.slice(:name,
                                 :comment_type,
                                 :output_content_type,
                                 :prompt,
                                 :extension,
                                 :highlight_mode,
                                 :visible_success_output,
                                 :devicon,
                                 :triable,
                                 :queriable,
                                 :stateful_console,
                                 :layout_js_urls,
                                 :layout_html_urls,
                                 :layout_css_urls,
                                 :editor_js_urls,
                                 :editor_html_urls,
                                 :editor_css_urls)
    save!
  end

  def directives_sections
    new_directive Mumukit::Directives::Sections
  end


  def assets_urls_for(kind, content_type)
    send "#{kind}_#{content_type}_urls"
  end

  # TODO this should be a Mumukit::Directives::Directive
  # and be part of a pipeline
  def interpolate_references_for(exercise, user, field)
    interpolate(field, user.interpolations, lambda { |content| replace_content_reference(exercise, user, content) })
  end

  private

  # TODO we should use Mumukit::Directives::Pipeline
  def interpolate(interpolee, *interpolations)
    interpolations.inject(interpolee) { |content, interpolation| directives_interpolations.interpolate(content, interpolation).first }
  end

  def directives_interpolations
    new_directive Mumukit::Directives::Interpolations
  end

  def replace_content_reference(exercise, user, interpolee)
    case interpolee
    when /previousContent|previousSolution/
      exercise.previous.current_content_for(user)
    when /(solution|content)\[(-?\d*)\]/
      exercise.sibling_at($2.to_i).current_content_for(user)
    end
  end

  def new_directive(directive_type)
    directive_type.new.tap { |it| it.comment_type = directives_comment_type }
  end

  def directives_comment_type
    Mumukit::Directives::CommentType.parse comment_type
  end
end
