module DiscussionsHelper
  def discussions_link(item)
    link_to t(:solve_your_doubts), polymorphic_path([item, :discussions])
  end

  def user_avatar(user, img_class='')
    image_tag user.image_url, height: 40, class: "img-circle #{img_class}"
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
end
