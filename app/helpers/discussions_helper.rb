module DiscussionsHelper
  def read_discussions_link(item)
    discussions_link t(:solve_your_doubts), polymorphic_path([item, :discussions], default_discussions_params)
  end

  def solve_discussions_link
    discussions_link t(:solve_doubts), discussions_path(solve_discussion_params_for(current_user))
  end

  def discussions_icon(text)
    fixed_fa_icon 'comments', text: text
  end

  def discussions_link(text, path, organization=Organization.current)
    link_to discussions_icon(text), path if organization.forum_enabled?
  end

  def solve_discussion_params_for(user)
    if user&.moderator?
      { status: :pending_review, sort: :created_at_asc }
    else
      { status: :opened, sort: :created_at_asc }
    end
  end

  def default_discussions_params
    { status: :solved, sort: :upvotes_count_desc }
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
          #{read_discussions_link(item)}
        </p>
      </div>
    }.html_safe
  end

  def discussion_messages_icon(discussion)
    %Q{
      <span class="discussion-icon fa-stack fa-xs">
        <i class="fa fa-comment-o fa-stack-2x"></i>
        <i class="fa fa-stack-1x">#{discussion.messages.size}</i>
      </span>
    }.html_safe
  end

  def discussion_upvotes_icon(discussion)
    if discussion.upvotes_count > 0
      %Q{
        <span class="discussion-icon fa-stack fa-xs">
          <i class="fa fa-star-o fa-stack-2x"></i>
          <i class="fa fa-stack-1x">#{discussion.upvotes_count}</i>
        </span>
      }.html_safe
    end
  end

  def discussion_update_status_button(status)
    button_to t("to_#{status}"), polymorphic_path([@debatable, @discussion], {status: status}),
              class: "btn btn-discussion-#{status}", :method => :put
  end

  def new_discussion_link(teaser_text, link_text)
    %Q{
      <h4>
        <span>#{t(teaser_text)}</span>
        <a>
          <span class="discussion-create">
            #{t(link_text)}
          </span>
        </a>
      </h4>
    }.html_safe
  end

  def discussion_count_for_status(status, discussions)
    discussions.scoped_query_by(@filter_params, :status).by_status(status).count
  end

  def discussions_reset_query_link
    link_to fa_icon(:times, text: t(:reset_query)), {}, class: 'discussions-reset-query' unless @filter_params.blank?
  end

  def discussions_statuses
    Mumuki::Laboratory::Status::Discussion::STATUSES
  end

  def discussions_languages(discussions)
    discussions.map { |it| it.language.name }.uniq
  end

  def discussion_status_filter_link(status, discussions)
    discussions_count = discussion_count_for_status(status, discussions)
    if status.should_be_shown?(discussions_count)
      discussion_filter_item(:status, status) do
        discussion_status_filter(status, discussions_count)
      end
    end
  end

  def discussion_status_filter(status, discussions_count)
    %Q{
      #{status_fa_icon(status)}
      <span>
        #{discussions_count}
        #{t status}
      </span>
    }.html_safe
  end

  def discussion_dropdown_filter(label, filters, &block)
    if filters.size > 0
      %Q{
        <div class="dropdown discussions-toolbar-filter">
          <a id="dropdown-#{label}" data-toggle="dropdown" role="menu">
            #{t label} #{fa_icon :'caret-down', class: 'fa-xs'}
          </a>
          <ul class="dropdown-menu" aria-labelledby="dropdown-#{label}">
            #{discussion_filter_list(label, filters, &block)}
          </ul>
        </div>
      }.html_safe
    end
  end

  def discussion_filter_list(label, filters, &block)
    filters.map { |it| discussion_filter_item(label, it, &block) }.join("\n")
  end

  def discussion_filter_item(label, filter, &block)
    content_tag(:li, discussion_filter_link(label, filter, &block), class: "#{'selected' if discussion_filter_selected?(label, filter)}")
  end

  def discussion_filter_selected?(label, filter)
    filter.to_s == @filter_params[label]
  end

  def discussion_filter_link(label, filter, &block)
    link_to capture(filter, &block), @filter_params.merge(Hash[label, filter])
  end

  def discussion_info(discussion)
     "#{t(:time_since, time: time_ago_in_words(discussion.created_at))} · #{t(:message_count, count: discussion.messages.size)}"
  end
end
