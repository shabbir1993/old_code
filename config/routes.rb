Pcms::Application.routes.draw do
  resources :films, except: [:show] do
    member do
      get :split
      put :create_split
      put :restore
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
  get 'history/master_films', to: 'history#master_films', as: :master_films_history

  get 'charts/stock_formula_totals', to: 'charts#stock_formula_totals', as: :stock_formula_totals_chart
  get 'charts/stock_film_type_totals', to: 'charts#stock_film_type_totals', as: :stock_film_type_totals_chart
  get 'charts/fg_utilization', to: 'charts#fg_utilization', as: :fg_utilization_chart


  root to: 'films#index', defaults: { scope: "lamination" }
end
