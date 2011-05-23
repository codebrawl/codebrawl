Codebrawl::Application.routes.draw do

  resources :contests

  root :to => 'contests#index'

end
