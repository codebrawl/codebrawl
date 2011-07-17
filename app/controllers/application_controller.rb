class ApplicationController < ActionController::Base
  protect_from_forgery

  def sitemap
    @data = []

    @data << {
      :loc => root_url,
      :lastmod => Contest.last.starting_on.to_s,
      :changefreq => 'weekly',
      :priority => 1
    }

    @data << {
      :loc => users_url,
      :lastmod => Contest.last.starting_on.to_s,
      :changefreq => 'weekly',
      :priority => 2
    }

    @data << {
      :loc => articles_url,
      :lastmod => File.mtime("#{Rails.root}/app/blog/index.html").to_date.to_s,
      :changefreq => 'weekly',
      :priority => 1
    }

    Dir.glob("app/blog/articles/*").each do |article|
      @data << {
        :loc => "#{articles_url}/#{File.basename(article)}",
        :lastmod => File.mtime("#{article}/index.html").to_date.to_s,
        :changefreq => 'weekly',
        :priority => 1
      }
    end

    @data << {
      :loc => url_for([:new, :submission]),
      :lastmod => Contest.last.starting_on.to_s,
      :changefreq => 'weekly',
      :priority => 2
    }

    User.all.each do |user|
      @data << {
        :loc => url_for(user),
        :lastmod => Contest.last.starting_on.to_s,
        :changefreq => 'monthly',
        :priority => 2
      }
    end

    Contest.all.each do |contest|
      @data << {
        :loc => url_for(contest),
        :lastmod => (contest.closing_on || contest.voting_on || contest.starting_on).to_s,
        :changefreq => 'weekly',
        :priority => 1
      }
    end

    respond_to { |format| format.xml { render :layout => false } }

  end

  protected

    def current_user
      @current_user ||= User.find(session[:user_id]) rescue nil if session[:user_id]
    end

    def logged_in?
      current_user.present?
    end

    def authenticate_user!
      redirect_to "/auth/github?origin=#{request.env['PATH_INFO']}" unless logged_in?
    end

    helper_method :current_user, :logged_in?
end
