module ApplicationHelper
  def highlighted_code(lang, code)
    "<pre><code class=\"hljs #{lang}\">#{code}</code></pre>".html_safe
  end
end
