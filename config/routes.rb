# frozen_string_literal: true

require 'api_constraints'
Rails.application.routes.draw do
  root 'errors#not_found'
  get '/400' => 'errors#bad_request'
  get '/404' => 'errors#not_found'
  get '/500' => 'errors#internal_server_error'

  scope '/api', defaults: { format: :json } do
    use_doorkeeper scope: 'v1/oauth'
    namespace :v1 do
      resources :users, except: %i[new edit], :id => /.*/
      # GET /users     # index
      # GET /users/:id # show
      # POST /users    # create
      # PUT /users/:id # update
      # DESTROY /users # destroy
      resources :sessions, only: %i[create]
      resources :details, only: %i[show], :id => /.*/
      resources :identity, only: %i[index]
      resources :applications, only: %i[show], :id => /.*/
      resources :keys, only: %i[index destroy]
      resources :logs, only: %i[index]
    end
  end
end
