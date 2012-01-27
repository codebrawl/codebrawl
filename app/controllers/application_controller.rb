class ApplicationController < ActionController::Base
  protect_from_forgery

  def rules
  end

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
      :priority => 0.6
    }

    @data << {
      :loc => articles_url,
      :lastmod => File.mtime("#{Rails.root}/app/blog/index.html").to_date.to_s,
      :changefreq => 'weekly',
      :priority => 0.8
    }

    @data << {
      :loc => rules_url,
      :lastmod => File.mtime("#{Rails.root}/app/views/application/rules.haml").to_date.to_s,
      :changefreq => 'weekly',
      :priority => 0.4
    }

    Dir.glob("app/blog/articles/*").each do |article|
      @data << {
        :loc => "#{articles_url}/#{File.basename(article)}",
        :lastmod => File.mtime("#{Rails.root}/#{article}/index.html").to_date.to_s,
        :changefreq => 'weekly',
        :priority => 0.7
      }
    end

    @data << {
      :loc => url_for([:new, :submission]),
      :lastmod => Contest.last.starting_on.to_s,
      :changefreq => 'weekly',
      :priority => 0.5
    }

    User.all.each do |user|
      @data << {
        :loc => url_for(user),
        :lastmod => Contest.last.starting_on.to_s,
        :changefreq => 'weekly',
        :priority => 0.5
      }
    end

    Contest.all.each do |contest|
      @data << {
        :loc => url_for(contest),
        :lastmod => (contest.closing_on || contest.voting_on || contest.starting_on).to_s,
        :changefreq => 'weekly',
        :priority => 0.9
      }
    end

    respond_to { |format| format.xml { render :layout => false } }

  end

  protected

    def current_user
      @current_user ||= User.first(:conditions => {:id => session[:user_id]}) if session[:user_id]
    end

    def logged_in?
      current_user.present?
    end

    def authenticate_user!
      redirect_to "/auth/github?origin=#{request.env['PATH_INFO']}" unless logged_in?
    end

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end

    helper_method :current_user, :logged_in?
end
