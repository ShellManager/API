class V1::DetailsController < V1::VersionController
  def show
    authenticated_user = User.find_by(api_key: bearer_token)
    searchable_user = User.where(email: params[:id])
                          .select(:id, :first_name, :last_name, :email, \
                                  :date_of_birth, :user_global_id, :api_key, \
                                  :activated, :active, :protected, :shell_username,
                                  :permission_level, :shell_active, :tfa_key, :tfa_enabled)
    if authenticated_user && searchable_user && authenticated_user.active && \
       (authenticated_user.permission_level <= 5 || authenticated_user.id == searchable_user.first.id)

      render json: { :user_details => searchable_user, :status => :ok }
    else
      render json: { :user_details => nil, :status => :unauthorized }
    end
  end
end
