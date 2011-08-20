Codebrawl::Application.routes.draw do

  resources :contests, :only => [:index, :show] do
    resources :entries, :only => [:show, :new, :create, :update, :destroy] do
      resources :votes, :only => [:create]
    end
  end

  resources :users, :only => [:index, :show]
  resource :session, :only => [:create, :destroy]
  resources :submissions, :only => [:new, :create]
  resources :suggestions, :only => :index

  resources :articles, :only => [:index, :show]

  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'
  match '/sitemap', :to => 'application#sitemap'

  get '/rules' => "application#rules", :as => 'rules'

  root :to => 'contests#index'

end
