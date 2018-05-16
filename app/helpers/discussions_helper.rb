module DiscussionsHelper
  def discussions_link(path)
    link_to t(:solve_your_doubts), path
  end

  def user_avatar(user)
    image_tag user.image_url, height: 40, class: 'img-circle'
  end
end
