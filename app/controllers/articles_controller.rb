class ArticlesController < ApplicationController
  def index
    get_data_and_content("#{Rails.root}/app/blog/index.html")
  end

  def show
    get_data_and_content("#{Rails.root}/app/blog/articles/#{params[:id]}/index.html")
    render :index
  end

  private

    def get_data_and_content(filename)
      content = File.read(filename)
      content =~ /^(---\s*\n.*?\n?)^(===\s*$\n?)/m

      @content = $'
      @data = YAML.load($1) || {}
    end
end