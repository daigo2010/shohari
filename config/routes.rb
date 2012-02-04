Shohari::Application.routes.draw do
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout", :to => "sessions#destroy", :as => :signout
  match ':controller(/:action(/:id))(.:format)'
  root :to => "top#index"
end
