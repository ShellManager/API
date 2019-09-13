class ErrorsController < ApplicationController
  def not_found
    render :json => { :status => "Resource #{request.original_fullpath} not found" }
  end

  def internal_server_error
    render :json => { :status => "Server error. Try again later" }
  end

  def bad_request
    render :json => { :status => "Bad request"}
  end
end
