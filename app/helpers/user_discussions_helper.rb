module UserDiscussionsHelper
  def user_discussions_table_title(discussion, user, last_read)
    %Q{
      <tr></tr>
      <thead>
        <tr>
          <td class="#{last_read.nil? ? '' : 'pt-5'}" colspan="4">
            <strong>#{discussion.read_by?(user) ? t(:discussions_read) : t(:discussions_unread)}</strong>
          </td>
        </tr>
      </thead>
    }.html_safe
  end

  def user_discussions_table_header
    %Q{
      <tr class="fw-bold">
        <td></td>
        <td>#{t(:exercise)}</td>
        <td>#{t(:discussion_created_by)}</td>
        <td>#{t(:last_message)}</td>
      </tr>
    }.html_safe
  end

  def user_discussions_table_item(discussion, user)
    %Q{
      <tr>
        <td class="text-center">
          #{icon_for_read(discussion.read_by?(user))}
        </td>
        <td>#{link_to discussion.item.name, item_discussion_path(discussion)}</td>
        <td>#{discussion_user_name discussion.initiator}</td>
        <td>#{t(:time_since, time: time_ago_in_words(discussion.last_message_date))}</td>
      </tr>
    }.html_safe
  end
end
