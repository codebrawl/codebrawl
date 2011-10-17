require 'sprockets/helpers/rails_helper'

module ApplicationHelper
  include Sprockets::Helpers::RailsHelper

  def avatar_url
    "http://#{request.subdomain.present? ? "#{request.subdomain}." : ''}" <<
    "#{request.domain}#{request.local? ? ":#{request.port}" : ''}" <<
    "#{asset_path('avatar.png')}"
  end

  def link_to_profile(user)
    link_text = image_tag(user.gravatar_url(:size => 20, :default => avatar_url), :class => 'gravatar')
    link_text << " " << user.name
    link_to link_text, user_path(user), :name => user.name
  end

  def clean_url(url)
    return url if url.include? '://'
    "http://#{url}"
  end

end
