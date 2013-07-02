Pcms::Application.routes.draw do
  resources :master_films

  resources :films, except: [:show, :index, :destroy] do
    member do
      get :split
    end
    collection do
      get :edit_multiple
      put :update_multiple
    end
  end

  get '/films/:scope', to: 'films#index', as: :films, 
                       defaults: { :scope => "lamination" }

  get '/imports', to: 'imports#home'
  post '/import_master_films', to: 'imports#import_master_films'
  post '/import_films', to: 'imports#import_films'
  post '/import_users', to: 'imports#import_users'
  post '/import_machines', to: 'imports#import_machines'
  post '/import_defects', to: 'imports#import_defects'

  root to: 'films#index', defaults: { :scope => "lamination" }
end
