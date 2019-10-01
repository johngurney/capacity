Rails.application.routes.draw do
  resources :areas
  resources :capacitylogs
  resources :capacitycodes
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepage#homepage'
  post 'upload_users_file', to:  "users#upload_users_file" , as:  :upload_users_file
  post 'cookie_consent'=> 'homepage#cookie_consent', as: :cookie_consent
  post 'log_in' => 'homepage#log_in', as: :log_in
  post 'log_out' => 'homepage#log_out', as: :log_out
  post 'cheat_log_in' => 'homepage#cheat_log_in', as: :cheat_log_in
  post 'new_capacity_log/.:id' => 'users#capacity_log', as: :new_capacity_log

  post 'test' => 'homepage#test', as: :test

end
