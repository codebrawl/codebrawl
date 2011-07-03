class ArticlesController < ApplicationController
  def show
    begin
      render :file => "#{Rails.root}/app/blog/articles/#{params[:id]}.html"
    rescue
      raise '404!'
    end
  end
end