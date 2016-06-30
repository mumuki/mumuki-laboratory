module WithComments
  def has_comments?
    comments_count > 0
  end

  def comments_count
    current_user.try(:unread_comments).try(:count) || 0
  end
end