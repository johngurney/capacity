Rails.application.routes.draw do
  resources :locations
  resources :departments
  resources :areas
  resources :capacitylogs
  resources :capacitycodes
  resources :users
  resources :groups

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepage#homepage'

  post 'upload_users_file', to:  "users#upload_users_file" , as:  :upload_users_file
  post 'upload_areas_file', to:  "areas#upload_areas_file" , as:  :upload_areas_file
  post 'upload_capcodes_file', to:  "capacitycodes#upload_capcodes_file" , as:  :upload_capcodes_file
  post 'upload_groups_file', to:  "groups#upload_groups_file" , as:  :upload_groups_file
  post 'upload_depts_file', to:  "departments#upload_file" , as:  :upload_depts_file
  post 'upload_locations_file', to:  "locations#upload_file" , as:  :upload_locations_file

  post 'cookie_consent'=> 'homepage#cookie_consent', as: :cookie_consent
  post 'log_in' => 'homepage#log_in', as: :log_in
  post 'log_out' => 'homepage#log_out', as: :log_out
  post 'cheat_log_in' => 'homepage#cheat_log_in', as: :cheat_log_in
  post 'new_capacity_log/.:id' => 'users#capacity_log', as: :new_capacity_log

  post 'set_allow_cheat_logon' => 'homepage#set_allow_cheat_logon', as: :set_allow_cheat_logon
  post 'amend_user_groups/.:id' => 'users#amend_user_groups', as: :amend_user_groups
  post 'assign_groups/.:id' => 'users#assign_groups', as: :assign_groups

  post 'set_group/.:id' => 'users#set_group_for_user', as: :set_group_for_user
  post 'select_groups' => 'users#select_groups', as: :select_groups
  post 'sgtwo' => 'users#select_group_for_logged_in_user', as: :select_group_for_logged_in_user

  post 'set_objective/.:id' => 'users#set_objective', as: :set_objective



  post 'test' => 'homepage#test', as: :test
  post 'delete_all' => 'homepage#delete_all', as: :delete_all

  post 'amend_aois/.:id' => 'users#amend_aois', as: :amend_aois
  get 'search_aois' => 'homepage#search_aois', as: :search_aois

  get 'passwords' => 'users#passwords', as: :passwords
  post 'make_passwords' => 'users#make_passwords', as: :make_passwords

  get 'history/.:id' => 'users#history', as: :history

  get 'selected_history' => 'users#selected_history', as: :selected_history
  get 'history_all' => 'homepage#history_all', as: :history_all

  get 'history_all_select_users' => 'homepage#history_all_select_users', as: :history_all_select_users

  post 'reset_cookie' => 'homepage#reset_cookie_consent', as: :reset_cookie_consent

  post 'ad_admin' => 'homepage#ad_admin', as: :ad_admin
end
