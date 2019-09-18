class V1::LogsController < V1::VersionController
  def index
    user = User.find_by(api_key: bearer_token)
    logs = Log.where(user: user.user_global_id)
                             .select(:id, :action, :administrative, :created_at)
    if user && logs
      render json: { :logs => logs, :status => :ok }
    else
      render json: { :logs => nil, :status => :unauthorized }
    end
  end
end
