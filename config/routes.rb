Rails.application.routes.draw do
  apipie
  root to: redirect('/apipie')

  scope 'api' do
    resources :resources, only: [:index]
    resources :survivors, only: [:index, :create, :show, :update]
    post :infected_report, to: 'infected_reports#create'
    post :exchanges,       to: 'exchanges#create'

    scope 'reports' do
      get :percentage_infected_survivors,     to: 'reports#percentage_infected_survivors'
      get :percentage_non_infected_survivors, to: 'reports#percentage_non_infected_survivors'
      get :average_resources_by_survivor,     to: 'reports#average_resources_by_survivor'
      get :points_lost_because_infected,      to: 'reports#points_lost_because_infected'
    end
  end

end
