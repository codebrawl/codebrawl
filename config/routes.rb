Codebrawl::Application.routes.draw do

  resources :contests, :only => [:index, :show] do
    resources :entries, :only => [:new, :create] do
      resources :votes, :only => [:create]
    end
  end

  resources :users, :only => :show

  resource :session, :only => [:create, :destroy]

  match '/auth/:provider/callback', :to => 'sessions#create'

  root :to => 'contests#index'

end
