module AvatarHelper
  def avatars_for(user)

    y = Avatar.new(image_url: "https://user-images.githubusercontent.com/11304439/86463651-4d24d600-bd04-11ea-90ac-20c0e9233632.png")
    m = Avatar.new(image_url: "https://user-images.githubusercontent.com/11304439/86463655-4dbd6c80-bd04-11ea-88c0-a39255598f29.png")
    k= Avatar.new(image_url: "https://user-images.githubusercontent.com/11304439/86463659-4dbd6c80-bd04-11ea-86cc-8c583bece858.png")
    desy = Avatar.new(image_url: "https://user-images.githubusercontent.com/11304439/86463667-501fc680-bd04-11ea-8339-d053db20adeb.png")
    desm = Avatar.new(image_url: "https://user-images.githubusercontent.com/11304439/86463670-501fc680-bd04-11ea-9251-6cd52e3f149d.png")
    desk = Avatar.new(image_url: "https://user-images.githubusercontent.com/11304439/86463674-5150f380-bd04-11ea-910a-b049971e9c8a.png")

    adul1 = Avatar.new(image_url: "https://user-images.githubusercontent.com/11304439/86463660-4e560300-bd04-11ea-82a9-8a5c99376437.png")
    adul2 = Avatar.new(image_url: "https://user-images.githubusercontent.com/11304439/86463661-4eee9980-bd04-11ea-8ed2-66a347093a76.png")
    adul3 = Avatar.new(image_url: "https://user-images.githubusercontent.com/11304439/86463666-4f873000-bd04-11ea-9398-cd069d3a8b2f.png")
    adul4 = Avatar.new(image_url: "https://user-images.githubusercontent.com/11304439/86463646-4ac27c00-bd04-11ea-9623-da0caea33bbc.png")
    adul5 = Avatar.new(image_url: "https://user-images.githubusercontent.com/11304439/86463649-4bf3a900-bd04-11ea-9a69-24759c88d757.png")
    adul6 = Avatar.new(image_url: "https://user-images.githubusercontent.com/11304439/86463650-4c8c3f80-bd04-11ea-8080-7d88ae47a21f.png")

    [adul1, adul2, adul3, adul4, adul5, adul6]
    [y, m, k, desy, desm, desk]
  end

  def show_avatar_item(item)
    "<img src='#{item.image_url}' alt='#{item.description}' mu-avatar-id='#{item.id}' class='mu-avatar-item'>".html_safe
  end
end
