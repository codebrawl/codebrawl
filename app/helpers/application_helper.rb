module ApplicationHelper

  def avatar_url
    "http://#{request.domain}#{request.local? ? ":#{request.port}" : ''}#{asset_path('avatar.png')}"
  end

  def link_to_profile(user)
    link_text = image_tag(user.gravatar_url(:size => 20, :default => avatar_url), :class => 'gravatar')
    link_text << " " << user.login
    link_to link_text, user_path(user), :name => user.login
  end

  def clean_url(url)
    return url if url.include? '://'
    "http://#{url}"
  end

end
