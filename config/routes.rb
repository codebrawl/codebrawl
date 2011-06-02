Codebrawl::Application.routes.draw do

  resources :contests, :only => [:index, :show] do
    resources :entries, :only => [:new, :create]
  end

  resource :session

  match '/auth/:provider/callback', :to => 'sessions#create'

  root :to => 'contests#index'

end
