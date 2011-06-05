Codebrawl::Application.routes.draw do

  resources :contests, :only => [:index, :show] do
    resources :votes, :only => [:create]
    resources :entries, :only => [:new, :create, :update, :destroy]
  end

  resources :users, :only => :show

  resource :session, :only => [:create, :destroy]

  match '/auth/:provider/callback', :to => 'sessions#create'

  root :to => 'contests#index'

end
