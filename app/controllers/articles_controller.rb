class ArticlesController < ApplicationController
  def index
    render :file => "#{Rails.root}/app/blog/index.html"
  end

  def show
    render :file => "#{Rails.root}/app/blog/articles/#{params[:id]}.html"
  end
end