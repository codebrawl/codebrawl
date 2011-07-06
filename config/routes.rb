Codebrawl::Application.routes.draw do

  resources :contests, :only => [:index, :show] do
    resources :entries, :only => [:new, :create, :update, :destroy] do
      resources :votes, :only => [:create]
    end
  end

  resources :users, :only => [:index, :show]
  resource :session, :only => [:create, :destroy]
  resources :submissions, :only => [:new, :create]

  resources :articles, :only => [:show]

  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'

  root :to => 'contests#index'

end
