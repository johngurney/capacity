Rails.application.routes.draw do
  resources :locations
  resources :departments
  resources :areas
  resources :capacitylogs
  resources :capacitycodes
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepage#homepage'
  post 'upload_users_file', to:  "users#upload_users_file" , as:  :upload_users_file
  post 'upload_areas_file', to:  "areas#upload_areas_file" , as:  :upload_areas_file
  post 'upload_capcodes_file', to:  "capacitycodes#upload_capcodes_file" , as:  :upload_capcodes_file


  post 'cookie_consent'=> 'homepage#cookie_consent', as: :cookie_consent
  post 'log_in' => 'homepage#log_in', as: :log_in
  post 'log_out' => 'homepage#log_out', as: :log_out
  post 'cheat_log_in' => 'homepage#cheat_log_in', as: :cheat_log_in
  post 'new_capacity_log/.:id' => 'users#capacity_log', as: :new_capacity_log

  post 'set_allow_cheat_logon' => 'homepage#set_allow_cheat_logon', as: :set_allow_cheat_logon



  post 'test' => 'homepage#test', as: :test
  post 'delete_all' => 'homepage#delete_all', as: :delete_all

  post 'amend_aois/.:id' => 'users#amend_aois', as: :amend_aois
  get 'search_aois' => 'homepage#search_aois', as: :search_aois

  get 'passwords' => 'users#passwords', as: :passwords
  post 'make_password/.:id' => 'users#make_password', as: :make_password
  post 'make_all_passwords' => 'users#make_all_passwords', as: :make_all_passwords
  get 'history/.:id' => 'users#history', as: :history

  get 'selected_history/.:id' => 'users#selected_history', as: :selected_history


end
