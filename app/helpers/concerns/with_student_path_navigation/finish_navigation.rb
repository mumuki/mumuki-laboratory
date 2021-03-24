module WithStudentPathNavigation
  class FinishNavigation < Navigation
    def button(navigable)
      return unless navigable.is_a?(Reading) && !navigable.status_for(current_user).like?(:passed)
      content_tag 'a', t(:finish), merge_confirmation_classes(navigable, class: clazz)
    end

    def clazz
      'btn btn-complementary w-100'
    end
  end
end
