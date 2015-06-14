module ApplicationHelper
  include LinksRendering
  include Icons
  include Flags

  def limit(items, preserve_order = false)
    limited = items.last(5)
    limited = limited.reverse unless preserve_order
    limited
  end

  def paginate(object, options={})
    "<div class=\"text-center\">#{super(object, {theme: 'twitter-bootstrap-3'}.merge(options))}</div>".html_safe
  end

  def link_to_tag_list(tags)
    tags.map { |tag| link_to "##{tag}", exercises_path(q: tag) }.join(', ').html_safe
  end

  def active_if(expected, current=@current_tab)
    'class="active"'.html_safe if expected == current
  end

  def time_ago_in_words_or_never(date)
    date ? time_ago_in_words(date) : t(:never)
  end

  def tab_list(tabs)
    ('<ul class="nav nav-tabs" role="tablist">' +
        tabs.map do |tab|
%Q{<li role="presentation" class="#{'active' if tab == tabs.first }">
<a href="##{tab}-panel" aria-controls="#{tab}" role="tab" data-toggle="tab">#{t(tab)}</a>
</li>}
        end.join("\n") +
        '</ul>').html_safe
  end

  def follow_button(user)
    restricted_to_other_user user do
      if current_user.following?(user)
        render 'users/unfollow', user: user, button_class: 'btn-warning'
      else
        render 'users/follow', user: user, button_class: 'btn-primary'
      end
    end
  end



  def next_guides_box(guide, options={})
    suggested = guide.next_guides
    if suggested.empty?
      nil
    elsif suggested.size == 1 || options[:only_first]
      link_to t(:next_guide), suggested.first, class: 'btn btn-success'
    else
      ('<ul class="list-group text-center">' +
      suggested.map {|it| "<li class=\"list-group-item\">#{link_to_guide(it)}</li>"}.join("\n")  +
      '</ul>').html_safe
    end
  end

  def corollary_box(with_corollary)
    if with_corollary.corollary.present?
      "<div><h3>#{t :corollary}</h3><p>#{with_corollary.corollary_html}</p></div>".html_safe
    end
  end


  def with_classifications(classifiable)
    classifications = []
    classifications << classifiable.name
    if classifiable.new?
      classifications << %Q{<span class="label label-success">#{fa_icon :certificate} #{t :new}</span>}
    end
    classifications.join(' ').html_safe
  end
end
