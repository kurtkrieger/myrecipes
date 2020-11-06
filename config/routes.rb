Rails.application.routes.draw do
  root "pages#home"
  get "/pages/home", to: "pages#home"
  
  resources :recipes
  
  # # List all
  # get "/recipes", to: "recipes#index"
  
  # # Create new
  # # Must come before /recipes/:id or "new" will be considered as an id value
  # get "/recipes/new", to: "recipes#new" 
  
  # # show one
  # get "/recipes/:id", to: "recipes#show", as: "recipe"
  
  # # receive new form data and create one
  # post "/recipes", to: "recipes#create"
  
  # # Edit one
  # get "/recipes/:id/edit", to: "recipes#edit"
  
  # # receive edit form data and update one
  # patch "/recipes/:id", to: "recipes#update"
  
  # # Destroy one
  # delete "/recipes/:id", to: "recipes#destroy"

end
