Rails.application.routes.draw do

  resources :maps, :only => [:index] do
    collection do
      get 'markers'
    end
  end

end
