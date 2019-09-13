# frozen_string_literal: true

require 'api_constraints'
Rails.application.routes.draw do
  root 'errors#not_found'
  get '/400' => 'errors#bad_request'
  get '/404' => 'errors#not_found'
  get '/500' => 'errors#internal_server_error'

  scope '/api', defaults: { format: :json } do
    namespace :v1 do
      resources :users, except: %i[new edit], :id => /.*/
      # GET /users     # index
      # GET /users/:id # show
      # POST /users    # create
      # PUT /users/:id # update
      # DESTROY /users # destroy
    end
  end
end
