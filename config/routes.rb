Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api' do
    resources :projects do
      resources :floorplans do
        match '*path', to: 'floorplans#image', via: [:get]
      end
    end
  end
end
