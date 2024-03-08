# Rails.application.routes.draw do
#   get 'api/encrypt'
#   get 'api/decrypt'
#   post '/api/encrypt', to: 'cype#encrypt'
#   post '/api/decrypt', to: 'cype#decrypt'
#   # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
# end
Rails.application.routes.draw do
  get '/api/encrypt'
  get '/api/decrypt'
  post '/api/encrypt', to: 'cype#encrypt'
  post '/api/decrypt', to: 'cype#decrypt'
end
