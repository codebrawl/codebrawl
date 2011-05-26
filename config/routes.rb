Codebrawl::Application.routes.draw do

  resources :contests, :only => [:index, :show] do
    resources :entries, :only => [:new, :create]
  end

  root :to => 'contests#index'

end
