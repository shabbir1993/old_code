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

  resources :master_films, only: [:index, :edit, :update]

  get 'imports', to: 'imports#home'
  post 'import_master_films', to: 'imports#import_master_films'
  post 'import_films', to: 'imports#import_films'
  post 'import_users', to: 'imports#import_users'
  post 'import_machines', to: 'imports#import_machines'
  post 'import_defects', to: 'imports#import_defects'
  post 'import_film_movements', to: 'imports#import_film_movements'
  post 'import_phase_snapshots', to: 'imports#import_phase_snapshots'

  get 'history/film_movements', to: 'history#film_movements', as: :film_movements_history
  get 'history/fg_film_movements', to: 'history#fg_film_movements', as: :fg_film_movements_history
  get 'history/scrap_film_movements', to: 'history#scrap_film_movements', as: :scrap_film_movements_history
  get 'history/reserved_checkouts', to: 'history#reserved_checkouts', as: :reserved_checkouts_history
  get 'history/phase_snapshots', to: 'history#phase_snapshots', as: :phase_snapshots_history

  get 'charts/stock_formula_totals', to: 'charts#stock_formula_totals', as: :stock_formula_totals_chart
  get 'charts/stock_film_type_totals', to: 'charts#stock_film_type_totals', as: :stock_film_type_totals_chart
  get 'charts/fg_utilization', to: 'charts#fg_utilization', as: :fg_utilization_chart
  get 'charts/master_film_yield', to: 'charts#master_film_yield', as: :master_film_yield_chart
  get 'charts/stock_dimensions', to: 'charts#stock_dimensions', as: :stock_dimensions_chart
  get 'charts/film_movement', to: 'charts#film_movement', as: :film_movement_chart
  get 'charts/daily_fg_movement', to: 'charts#daily_fg_movement', as: :daily_fg_movement_chart
  get 'charts/stock_snapshots', to: 'charts#stock_snapshots', as: :stock_snapshots_chart


  root to: 'films#index', defaults: { scope: "lamination" }
end
