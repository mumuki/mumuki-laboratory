module CodemirrorHelper
  def codemirror_assets_base_url
    '//cdnjs.cloudflare.com/ajax/libs/codemirror/5.30.0'
  end

  def codemirror_assets_js
    %w(
      codemirror.min.js
      mode/ruby/ruby.min.js
      mode/haskell/haskell.min.js
      mode/javascript/javascript.min.js
      mode/markdown/markdown.min.js
      mode/python/python.min.js
      mode/clike/clike.min.js
      mode/htmlmixed/htmlmixed.min.js
      mode/sql/sql.min.js
      mode/css/css.min.js
      addon/edit/closebrackets.min.js
      addon/edit/matchbrackets.min.js
      addon/display/placeholder.min.js
      addon/display/fullscreen.min.js
      addon/hint/show-hint.min.js
      addon/hint/javascript-hint.min.js
    ).map { |it| "#{codemirror_assets_base_url}/#{it}" }
  end

  def codemirror_assets_css
    %w(
      codemirror.min.css
      addon/hint/show-hint.min.css
      addon/display/fullscreen
    ).map { |it| "#{codemirror_assets_base_url}/#{it}" }
  end
end
