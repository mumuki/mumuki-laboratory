module LinksHelper

  def link_to_path_element(element, options={})
    name = extract_name element, options
    link_to name, element, options
  end

  def link_to_error_404
    "<a href='https://es.wikipedia.org/wiki/Error_404'> #{I18n.t(:error_404)} </a>"
  end

  def link_to_issues(translation)
    "<a href='https://github.com/mumuki/mumuki-laboratory/issues/new'> #{I18n.t(translation)} </a>"
  end

  def link_to_status_codes(code)
    "<a href='https://es.wikipedia.org/wiki/Anexo:C%C3%B3digos_de_estado_HTTP'> #{I18n.t("error_#{code}")} </a>"
  end

  def url_for_application(app_name)
    app = Mumukit::Platform.application_for(app_name)
    app.organic_url(Organization.current.name)
  end

  def link_to_bibliotheca_guide(guide)
    edit_link_to_bibliotheca { url_for_bibliotheca_guide(guide) }
  end

  def link_to_bibliotheca_exercise(exercise)
    edit_link_to_bibliotheca { "#{url_for_bibliotheca_guide(exercise.guide)}/exercises/#{exercise.bibliotheca_id}" }
  end

  def mail_to_administrator
    mail_to Organization.current.contact_email,
            Organization.current.contact_email,
            subject: I18n.t(:permissions),
            body: permissions_help_email_body(current_user)
  end

  def turbolinks_enable_for(exercise)
    %Q{data-turbolinks="#{!exercise.input_kids?}"}.html_safe
  end

  private

  def extract_name(named, options)
    case options.delete(:mode)
      when :plain
        named.name
      when :friendly
        named.friendly
      else
        named.navigable_name
    end
  end

  def edit_link_to_bibliotheca
    return unless current_user&.writer?

    url = yield
    link_to fixed_fa_icon(:pencil), url, class: "mu-edit-link", target: "_blank", alt: t(:edit)
  end

  def url_for_bibliotheca_guide(guide)
    "#{url_for_application(:bibliotheca)}/#/guides/#{guide.slug}"
  end
end
