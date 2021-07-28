module UserDiscussionsHelper
  def user_discussions_table_header
    %Q{
      <tr>
        <td></td>
        <td><strong>#{t(:exercise)}</strong></td>
        <td><strong>#{t(:discussion_created_by)}</strong></td>
        <td><strong>#{t(:last_message)}</strong></td>
      </tr>
    }.html_safe
  end
end
