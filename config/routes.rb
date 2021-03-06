Codebrawl::Application.routes.draw do

  resources :contests, :only => [:index, :show] do
    resources :entries, :only => [:show, :new, :create, :update, :destroy] do
      resources :votes, :only => [:create]
    end
  end

  resources :users, :only => [:index, :show]
  match '/contributors', :to => 'users#contributors'

  resource :session, :only => [:create, :destroy]
  resources :submissions, :only => [:new, :create]

  resources :articles, :only => [:index, :show]

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'
  match '/sitemap' => 'application#sitemap'

  get '/rules' => "application#rules", :as => 'rules'

  root :to => 'homepage#index'

end
