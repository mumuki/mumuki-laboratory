module DiscussionsHelper
  def read_discussions_link(item)
    discussions_link others_discussions_icon(t(:solve_your_doubts)), item_discussions_path(item, default_discussions_params), class: 'dropdown-item'
  end

  def kids_read_discussions_link(item)
    discussions_link fixed_fa_icon('question-circle'), item_discussions_path(item, default_discussions_params), title: t(:solve_your_doubts), class: 'mu-kids-discussion-link'
  end

  def solve_discussions_link
    discussions_link others_discussions_icon(t(:solve_doubts)), discussions_path(solve_discussion_params_for(current_user)), class: 'dropdown-item' if current_access_mode.resolve_discussions_here?
  end

  def user_discussions_link
    discussions_link(user_discussions_icon(t(:my_doubts)), discussions_user_path, class: 'dropdown-item') if current_user.watched_discussions.present?
  end

  def others_discussions_icon(text)
    fixed_fa_icon 'comments', text: text
  end

  def user_discussions_icon(text)
    fixed_fa_icon 'comment', text: text
  end

  def discussions_link(item, path, html_options = nil)
    return unless current_user&.can_discuss_here?
    link_to item, path, html_options
  end

  def item_discussion_path(discussion, params = {})
    polymorphic_path([discussion.item, discussion], params)
  end

  def item_discussions_path(item, params = {})
    polymorphic_path([item, :discussions], params)
  end

  def solve_discussion_params_for(user)
    if user&.moderator_here?
      {status: :pending_review, sort: :responses_count_asc, requires_attention: true}
    else
      {status: :opened, sort: :responses_count_desc}
    end
  end

  def default_discussions_params
    {status: :solved, sort: :created_at_desc, recent: true, limit: 15}
  end

  def user_avatar(user, image_class='')
    profile_picture_for(user, class: image_class)
  end

  def forum_terms_link
    <<~HTML.html_safe
      <span>
        #{ t(:forum_terms_link, terms_link: link_to_forum_terms).html_safe }
      </span>
    HTML
  end

  def discussion_messages_count(discussion)
    <<~HTML.html_safe
      <span class="discussion-messages-count">
        #{fa_icon :comments, type: :regular, text: discussion.messages_count}
      </span>
    HTML
  end

  def discussion_validated_messages_count(discussion)
    <<~HTML.html_safe
      <span class="discussion-validated-messages-count">
        #{fa_icon :comment, type: :regular}#{fa_icon :check, text: discussion.validated_messages_count}
      </span>
    HTML
  end

  def discussion_upvotes_icon(discussion)
    if discussion.upvotes_count > 0
      <<~HTML.html_safe
        <span class="discussion-icon fa-stack fa-xs">
          <i class="far fa-star fa-stack-2x"></i>
          <i class="fas fa-stack-1x">#{discussion.upvotes_count}</i>
        </span>
      HTML
    end
  end

  def discussion_update_status_button(status)
    button_to t("to_#{status}"),
              item_discussion_path(@discussion, {status: status}),
              class: "btn btn-#{btn_type_for_discussion_statuses[status.to_sym]}",
              method: :put
  end

  def btn_type_for_discussion_statuses
    { closed: 'danger', solved: 'success', opened: 'light' }
  end

  def new_discussion_link(teaser_text, link_text)
    <<~HTML.html_safe
      <h4>
        <span>#{t(teaser_text)}</span>
        #{link_to t(link_text), new_exercise_discussion_path(@debatable, anchor: 'new-discussion-description-container') }
      </h4>
    HTML
  end

  def discussion_status_counts(discussions)
    discussions.scoped_query_by(discussion_filter_params, excluded_params: [:status], excluded_methods: [:page])
               .group(:status)
               .reorder('')
               .pluck(:status, 'count(*)')
               .to_h
               .transform_keys(&:to_sym)
  end

  def discussions_reset_query_link
    link_to fa_icon(:times, text: t(:reset_query)), {}, class: 'discussions-reset-query' unless discussion_filter_params.blank?
  end

  def discussions_statuses
    Mumuki::Domain::Status::Discussion::STATUSES
  end

  #TODO: this one uses a long method chain in order to take advantage of eager load
  # Delegate it once again when polymorphic association is removed
  def discussions_languages(discussions)
    @languages ||= discussions.distinct
                              .joins(:exercise)
                              .pluck('languages.name')
  end

  def discussion_status_filter_links(discussions)
    status_counts = discussion_status_counts(discussions)

    discussions_statuses.map do |status|
      discussion_status_filter_link(status, status_counts)
    end.compact.join("\n").html_safe
  end

  def discussion_status_filter_link(status, status_counts)
    discussions_count = status_counts[status.to_sym] || 0
    if status.should_be_shown?(discussions_count, current_user)
      discussion_filter_item(:status, status) do
        discussion_status_filter(status, discussions_count)
      end
    end
  end

  def discussion_status_filter(status, discussions_count)
    <<~HTML.html_safe
      #{discussion_status_fa_icon(status)}
      <span>
        #{t("#{status}_count", count: discussions_count)}
      </span>
    HTML
  end

  def discussion_dropdown_filter(label, filters, can_select_all = false, &block)
    if filters.present?
      <<~HTML.html_safe
        <div class="dropdown discussions-toolbar-filter">
          <a id="dropdown-#{label}" data-bs-toggle="dropdown" role="menu">
            #{t label} #{fa_icon :'caret-down', class: 'fa-xs'}
          </a>
          <ul class="dropdown-menu" aria-labelledby="dropdown-#{label}">
            #{discussion_filter_unselect_item(label, can_select_all)}
            #{discussion_filter_list(label, filters, &block)}
          </ul>
        </div>
      HTML
    end
  end

  def discussion_filter_list(label, filters, &block)
    filters.map { |it| discussion_filter_item(label, it, 'dropdown-item', &block) }.join("\n")
  end

  def discussion_filter_item(label, filter, link_class=nil, &block)
    content_tag(:li, discussion_filter_link(label, filter, link_class, &block), class: ('selected' if discussion_filter_selected?(label, filter)))
  end

  def discussion_filter_unselect_item(label, can_select_all)
    if can_select_all
      content_tag(:li,
                  link_to(t(:all), discussion_filter_params_without_page.except(label), class: 'dropdown-item'),
                  class: ('selected' unless discussion_filter_params.include?(label)))
    end
  end

  def discussion_filter_selected?(label, filter)
    filter.to_s == discussion_filter_params[label]
  end

  def discussion_filter_link(label, filter, clazz, &block)
    link_to capture(filter, &block), discussion_filter_params_without_page.merge(Hash[label, filter]), class: clazz
  end

  def discussion_info(discussion)
    <<~HTML.html_safe
      <span>#{friendly_time(discussion.created_at, :time_since)}</span>
      <span> · #{t(:reply_count, count: discussion.visible_messages.size)}</span>
    HTML
  end

  def discussion_filter_params_without_page
    discussion_filter_params.except(:page)
  end

  def should_show_approved_for?(user, message)
    !user&.moderator_here? && message.approved? && !message.from_moderator?
  end

  def discussion_user_name(user)
    user.abbreviated_name
  end

  def linked_discussion_user_name(user)
    content_tag :a, discussion_user_name(user)
  end

  def responsible_moderator_text_for(discussion, user)
    if discussion.responsible?(user)
      t('moderator_take_care.you_are')
    else
      t('moderator_take_care.moderator_is', moderator: discussion_user_name(discussion.responsible_moderator_by))
    end
  end

  def responsible_icon
    fa_icon 'hand-paper', text: t('moderator_take_care.i_will')
  end

  def not_responsible_icon
    fa_icon 'hand-rock', type: :regular, text: t('moderator_take_care.i_wont')
  end

  def subscription_icon
    fa_icon :bell, text: t(:subscribe)
  end

  def unsubscription_icon
    fa_icon :bell, type: :regular, text: t(:unsubscribe)
  end

  def upvote_icon
    fa_icon 'thumbs-up', text: t(:upvote)
  end

  def undo_upvote_icon
    fa_icon 'thumbs-up', type: :regular, text: t(:undo_upvote)
  end

  def discussion_delete_message_link(discussion, message)
    link_to fa_icon('trash-alt', type: :regular, class: 'fa-lg'), discussion_message_path(discussion, message, motive: :self_deleted),
            method: :delete, data: { confirm: t(:are_you_sure, action: t(:destroy_message)) }, class: 'discussion-delete-message'
  end

  def discussion_delete_message_dropdown(discussion, message)
    <<~HTML.html_safe
      <span class="dropdown">
        #{content_tag :span, fa_icon('trash-alt', type: :regular, class: 'fa-lg'), role: 'menu', 'data-bs-toggle': 'dropdown',
                      class: 'discussion-delete-message', id: 'deleteDiscussionDropdown'}
        <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="deleteDiscussionDropdown">
          #{discussion_delete_message_option discussion, message, :inappropriate_content, 'times-circle'}
          #{discussion_delete_message_option discussion, message, :shares_solution, :code}
          #{discussion_delete_message_option discussion, message, :discloses_personal_information, 'user-tag'}
        </ul>
      </span>
    HTML
  end

  def discussion_delete_message_option(discussion, message, motive, icon)
    <<~HTML.html_safe
      <li>
        #{link_to fa_icon(icon, text: t("deletion_motive.#{motive}.present"), class: 'fa-fw fixed-icon'),
                  discussion_message_path(discussion, message, motive: motive), method: :delete, class: 'dropdown-item',
                  role: 'menuitem', data: { confirm: t(:are_you_sure, action: t(:destroy_message)) } }
      </li>
    HTML
  end

  def message_deleted_text(message)
    t(:message_deleted, motive: t("deletion_motive.#{message.deletion_motive}.past").downcase, forum_terms: link_to_forum_terms).html_safe
  end
end
