module DiscussionsHelper
  def discussions_link(item)
    link_to t(:solve_your_doubts), polymorphic_path([item, :discussions])
  end

  def solve_discussions_link(item)
    link_to t(:solve_doubts), polymorphic_path([item, :discussions], helping: true)
  end

  def user_avatar(user, image_class='')
    image_tag user.image_url, height: 40, class: "img-circle #{image_class}"
  end

  def discussions_link_with_teaser(item)
    %Q{
      <div>
        <h3>#{t(:discussions)}</h3>
        <p>
          #{t(:solve_your_doubts_teaser)}
          #{discussions_link(item)}
        </p>
      </div>
    }.html_safe
  end

  def discussion_messages_icon(discussion)
    %Q{
      <span class="discussion-messages-icon fa-stack fa-xs">
        <i class="fa fa-comment-o fa-stack-2x"></i>
        <i class="fa fa-stack-1x">#{discussion.messages.size}</i>
      </span>
    }.html_safe
  end

  def discussion_update_status_button(status)
    button_to t("to_#{status}"), polymorphic_path([@debatable, @discussion], {status: status}), class: "btn btn-discussion-#{status}", :method => :put
  end

  def new_discussion_link(teaser_text, link_text)
    %Q{
      <h4>
        <span>#{t(teaser_text)}</span>
        <a>
          <span id="discussion-create">
            #{t(link_text)}
          </span>
        </a>
      </h4>
    }.html_safe
  end

  def should_render_discussion_tabs?(discussion)
    true
  end

  def discussions_count_for_status(status)
    @discussions.for_status(status).count
  end

  def discussions_languages
    @discussions.map { |it| it.language.name }.uniq
  end

  def discussion_status_filter(status)
    %Q{
      #{status_fa_icon(status)}
      <span>
        #{discussions_count_for_status(status)}
        #{t status}
      </span>
    }.html_safe
  end

  def discussion_dropdown_filter(label, &block)
    %Q{
      <div class="dropdown discussions-toolbar-filter">
        <a id="dropdown-#{label}" data-toggle="dropdown" role="menu">
          #{t label} #{fa_icon :'caret-down', class: 'fa-xs'}
        </a>
        <ul class="dropdown-menu" aria-labelledby="dropdown-#{label}">
          #{capture(&block)}
        </ul>
      </div>
    }.html_safe
  end
end
