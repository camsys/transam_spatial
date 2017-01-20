Rails.application.routes.draw do

  resources :maps, :only => [] do
    collection do
      get 'map'
      get 'markers'
    end

    member do 
      get 'map_popup'
    end
  end

  resources :map_searches, :only => [] do
    collection do
      post 'geojson'
    end
  end

  resources :map_overlay_services

end
