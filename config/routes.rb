WhereAreMyFriends::Application.routes.draw do
  get "map_my_friends/index"
  root to: "map_my_friends#index"

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy'
  match '/signin' => 'sessions#new'
end
