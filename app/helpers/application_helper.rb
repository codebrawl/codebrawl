module ApplicationHelper

  def avatar_url
    "http://#{request.domain}#{request.local? ? ":#{request.port}" : ''}#{asset_path('avatar.png')}"
  end

end
