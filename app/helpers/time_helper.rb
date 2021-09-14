module TimeHelper
  def friendly_time(time, t_key = nil)
    friendly_time = time_ago_in_words time
    friendly_time_t = t_key ? t(t_key, time: friendly_time) : friendly_time

    <<~HTML.html_safe
      <time title="#{time}">
        #{friendly_time_t}
      </time>
    HTML
  end
end
