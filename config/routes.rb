Pcms::Application.routes.draw do
  resources :films, except: [:show, :destroy] do
    member do
      get :split
      put :create_split
    end
    collection do
      get :edit_multiple
      put :update_multiple
    end
  end

  get 'imports', to: 'imports#home'
  post 'import_master_films', to: 'imports#import_master_films'
  post 'import_films', to: 'imports#import_films'
  post 'import_users', to: 'imports#import_users'
  post 'import_machines', to: 'imports#import_machines'
  post 'import_defects', to: 'imports#import_defects'
  post 'import_film_movements', to: 'imports#import_film_movements'

  get 'history/film_movements', to: 'history#film_movements', as: :film_movements_history
  get 'history/fg_film_movements', to: 'history#fg_film_movements', as: :fg_film_movements_history

  get 'charts/stock_film_types', to: 'charts#stock_film_types', as: :stock_film_types_chart
  get 'charts/stock_formulas', to: 'charts#stock_formulas', as: :stock_formulas_chart

  root to: 'films#index', defaults: { scope: "lamination" }
end
