module ApplicationHelper
  def avatar_for(user, classes: "size-12")
    source = user.avatar_source
    return image_tag(source, alt: "#{user.full_name} avatar", class: "#{classes} rounded-full object-cover") if source

    content_tag(:span, user.full_name.to_s.first(2).upcase,
                class: "#{classes} inline-flex items-center justify-center rounded-full bg-indigo-100 font-semibold text-indigo-700",
                role: "img", "aria-label": "#{user.full_name} initials")
  end
end
