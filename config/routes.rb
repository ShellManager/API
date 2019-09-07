require 'api_constraints'
Rails.application.routes.draw do
  get '/404' => "errors#not_found"
  get '/500' => "errors#internal_server_error"
  scope '/api', defaults: { :format => :json } do
    namespace :v1 do
      resources :users
    end
  end
end
