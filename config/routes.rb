# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/23/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

MDme::Application.routes.draw do
  #TODO change doctors subdomain to clinical
  require 'domains'

  # match '/', to: 'static_pages#home', via: 'get'
  #doctor subdomain
  match '/', to: 'doctors#signin', via: 'get', constraints: { subdomain: 'doctors' }


  #admin subdomain
  match '/',     to: 'admins#signin',           via: 'get',    constraints: { subdomain: 'admin' }
  #constraints(RootDomain) do
  #constraints subdomain: false do
  root 'static_pages#home', constraints: { subdomain: 'www' }
  #match '/signup',    to: 'patients#new',           via: 'get',    constraints: { subdomain: 'www' }
  match '/help',            to: 'static_pages#help',     via: 'get'#,    constraints: { subdomain: 'www' }
  match '/about',           to: 'static_pages#about',    via: 'get'#,    constraints: { subdomain: 'www' }
  match '/contact',         to: 'static_pages#contact',  via: 'get'#,    constraints: { subdomain: 'www' }
  match '/signin',          to: 'sessions#new',          via: 'get'#,    constraints: { subdomain: 'www' }
  match '/signout',         to: 'sessions#destroy',      via: 'delete'
  match '/forgot_password', to: 'password_reset#new',    via: 'get',    as: :forgot_password
  match '/forgot_password', to: 'password_reset#create', via: 'post',   as: :password_reset


  post '/submit-comment'                                 => 'static_pages#submit_comment',             as: :contact_comment_path

  get  'patients/:patient_id/clinics/get-doctors'        => 'patients/clinics#get_doctors',            as: :patient_clinic_get_doctors
  get  'patients/:id/menu'                               => 'patients#menu',                           as: :patient_mobile_menu
  get  'patients/:patient_id/appointments/menu'          => 'patients/appointments#menu',              as: :patient_appointment_mobile_menu
  get  'patients/:patiend_id/appointments/browse'        => 'patients/appointments#open_appointments', as: :open_appointments_browse
  get  'patients/:patient_id/appointments/requests'      => 'patients/appointments#open_requests',     as: :open_requests
  get  'patients/:id/changepassword'                     => 'patients#change_password',                as: :patient_password
  patch 'patients/:id/update-password'                     => 'patients#update_password',                as: :patient_update_password

  get  'admins/:admin_id/doctors/search'                 => 'admins/doctors#search',                   as: :admin_doctors_search
  get  'admins/:admin_id/patients/search'                => 'admins/patients#search',                  as: :admin_patient_search
  get  'admins/:admin_id/patients/browse'                => 'admins/patients#browse',                  as: :admin_patients_browse
  get  'admins/:admin_id/patients/:id/registration-form' => 'admins/patients#registration_form',       as: :admin_patient_registration_form
  get  'admins/:admin_id/appointments/browse'            => 'admins/appointments#browse',              as: :admin_appointments_browse
  get  'admins/:admin_id/appointments/ajax-browse'       => 'admins/appointments#ajax_browse',         as: :appointments_ajax_browse
  get  'admins/:admin_id/appointments/new/browse'        => 'admins/appointments#new_browse',          as: :admin_open_appointments_browse
  get  'admins/:admin_id/appointments/approval'          => 'admins/appointments#approval',            as: :appointment_approval
  get  'admins/:admin_id/appointments/requests/ondate/:date'   => 'admins/appointments#show_on_date',        as: :appointment_show_on_date
  get  'admins/:admin_id/appointments/delays'            => 'admins/appointments#manage_delays',       as: :manage_delays
  post 'admins/:admin_id/appointments/add_delay'         => 'admins/appointments#add_delay',           as: :add_delay
  post 'admins/:admin_id/appointments/approvedeny'       => 'admins/appointments#approve_deny',        as: :appointment_approve_deny
  post 'admins/:admin_id/appointments/notify_ready'      => 'admins/appointments#notify_ready',        as: :notify_appointment_ready
  get  'admins/:admin_id/doctors/opentimes'              => 'admins/doctors#open_times',               as: :admin_doctors_opentimes
  get  'patients/:admin_id/doctors/opentimes'            => 'patients/appointments#open_times',        as: :patients_doctors_opentimes
  get  'clinics/:clinic_id/doctors/opentimes'            => 'clinics/doctors#open_times',              as: :clinics_doctor_opentimes
  get  'doctors/opentimes'                               => 'doctors#open_appointments',               as: :doctor_open_appointments
  get  'doctors/:id/public'                              => 'doctors#show_public',                     as: :doctor_public_show
  get  'doctors/:id/changepassword'                      => 'doctors#change_password',                 as: :doctor_password
  post 'doctors/:id/updatepassword'                      => 'doctors#update_password',                 as: :doctor_update_password

  get 'clinics/:id/checkin/:patient_id'                  => 'clinics#checkin',                         as: :clinic_checkin

  get 'appointments/:id/fill_appointment'                => 'appointments#fill_appointment',           as: :fill_appointment
  get  'patients/get-upcoming-appointment'               => 'patients#get_upcoming_appointment'

  #resources :departments
  resources :patients, except: [:new, :create, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :admins, only: [:index]
  #resources :appointments
  resources :doctors, except: [:new, :create, :destroy]

  resources :doctors do
    resources :appointments, only: [:index, :show], controller: 'doctors/appointments'
    resources :patients,     only: [:index, :show], controller: 'doctors/patients'
  end

  resources :patients do
    resources :appointments, controller: 'patients/appointments'
    resources :doctors, only: [:index, :show], controller: 'patients/doctors'
    resources :clinics, only: [:index, :show], controller: 'patients/clinics'
  end

  resources :clinics do
    resources :doctors, controller: 'clinics/doctors'
  end



  resources :admins do
    resources :departments,  controller: 'admins/departments'
    resources :patients,     controller: 'admins/patients'
    resources :doctors,      controller: 'admins/doctors'
    resources :appointments, controller: 'admins/appointments'
    resources :clinics,      controller: 'admins/clinics'
  end

  namespace :api do
    namespace :v1 do
      post 'sessions' => 'sessions#create', :as => 'login'
      delete 'sessions' => 'sessions#destroy', :as => 'logout'
      resources :patients, controller: 'patients', only: [:index]
      get 'patients/show' => 'patients#show', as: 'patient_profile'
      put 'patients/update' => 'patients#update', as: 'patient_update_profile'

      namespace :patients do
        get 'appointments/confirmed' => 'appointments#confirmed_appointments', as: 'confirmed_appointments'
        get 'appointments/requested' => 'appointments#requested_appointments', as: 'requested_appointments'
        resources :doctors, controller: 'doctors', only: [:index, :show]
        resources :appointments, controller: 'appointments', only: [:create, :update, :show, :index]
        resources :clinics, controller: 'clinics', only: [:index, :show]
        resources :devices, controller: 'devices', only: [:create]
        get 'departments' => 'doctors#department_index', as: 'doctors_departments'

      end
    end
    namespace :v2 do
      post 'login' => 'sessions#create', :as => 'login'
      post 'api_login' => 'sessions#api_login', as: 'api_login'
      get 'get_token' => 'sessions#get_token', as: 'get_token'
      delete 'sessions' => 'sessions#destroy', :as => 'logout'
    end
  end




  #api routes
  # namespace :api, :version => 1 do
  #   resources :patients, :only => [:index, :show],
  # end


   # end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
