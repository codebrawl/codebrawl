Codebrawl::Application.routes.draw do

  resources :contests, :only => [:new, :create, :edit, :update, :index, :show] do
    resources :votes, :only => [:create]
    resources :entries, :only => [:new, :create, :update, :destroy]
  end

  resources :users, :only => :show
  resources :submissions, :only => [:new, :create]

  resource :session, :only => [:create, :destroy]

  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'

  root :to => 'contests#index'

end
