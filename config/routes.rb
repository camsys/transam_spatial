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
      post 'map'
    end
  end

end
