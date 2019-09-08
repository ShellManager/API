class V1::VersionController < ApplicationController
  def index
    caller = controller_name.singularize
    render :json => {"#{caller}_count" => (caller.capitalize.constantize).all.count, :status => :ok}
  end
end
