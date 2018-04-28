Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    root to: 'articles#index'
    resources :articles do
    resources :comments
    end
   resources :tags
   resources :users
   resources :authors
     #get 'login'  => 'user_sessions#new'
     #get 'logout' => 'user_sessions#destroy'
  end
   resources :user_sessions, only: [ :new, :create, :destroy ]
   get 'login'  => 'user_sessions#new'
   get 'logout' => 'user_sessions#destroy'
   root to: 'pages#index'
   resources :pages
   get '/tags/:tag', :controller => 'pages', :action => 'tag_page'
   get '/author/:author', :controller => 'pages', :action => 'author_page'
end
