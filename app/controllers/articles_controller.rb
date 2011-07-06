class ArticlesController < ApplicationController
  def show
    render :file => "#{Rails.root}/app/blog/articles/#{params[:id]}.html"
  end
end