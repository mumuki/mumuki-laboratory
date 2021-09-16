module UserDiscussionsHelper
  def user_discussions_table_title(discussion, user, last_read)
    <<~HTML.html_safe
      <tr></tr>
      <thead>
        <tr>
          <td class="#{last_read.nil? ? '' : 'pt-5'}" colspan="4">
            <strong>#{discussion.read_by?(user) ? t(:discussions_read) : t(:discussions_unread)}</strong>
          </td>
        </tr>
      </thead>
    HTML
  end

  def user_discussions_table_header
    <<~HTML.html_safe
      <tr class="fw-bold">
        <td></td>
        <td>#{t(:exercise)}</td>
        <td>#{t(:discussion_created_by)}</td>
        <td>#{t(:last_message)}</td>
      </tr>
    HTML
  end

  def user_discussions_table_item(discussion, user)
    <<~HTML.html_safe
      <tr>
        <td class="text-center">
          #{icon_for_read(discussion.read_by?(user))}
        </td>
        <td>#{link_to discussion.item.name, item_discussion_path(discussion)}</td>
        <td>#{discussion_user_name discussion.initiator}</td>
        <td>#{friendly_time(discussion.last_message_date, :time_since)}</td>
      </tr>
    HTML
  end
end
