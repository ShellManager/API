class V1::IdentityController < V1::VersionController
  before_action :doorkeeper_authorize!

  def index
    authenticated_user = User.find_by(api_key: bearer_token)
    user = current_resource_owner.as_json(except: \
           %i[id date_of_birth api_key activated protected permission_level \
           tfa_key tfa_enabled password_digest password_hash encryption_key \
           last_login_ip fingerprints activation_token updated_at])
    searchable_user = User.where(email: params[:id])
                          .select(:id, :first_name, :last_name, :email, \
                                  :date_of_birth, :user_global_id, :api_key, \
                                  :activated, :active, :protected,
                                  :permission_level, :tfa_key, :tfa_enabled)
      render json: { :user_details => user, :status => :ok }
  end

  private

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
