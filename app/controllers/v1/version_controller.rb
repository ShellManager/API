class V1::VersionController < ApplicationController
  def index
    caller = controller_name.singularize
    model = caller.capitalize.constantize
    render json: { "#{caller}_count" => model.all.count, :status => :ok } if defined? model
    render json: { status: "Resource #{request.original_fullpath} not found" } unless defined? model
  end
end

