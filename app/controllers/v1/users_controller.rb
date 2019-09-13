# frozen_string_literal: true

class V1::UsersController < V1::VersionController
  def index
    super
  end
  
  def show
    user = User.find_by(shell_username: params[:id])
    render json: { user_exists: true, status: :ok } unless user.blank?
    render json: { user_exists: false, status: :ok } if user.blank?
  end

  def create
    user = User.new(create_params)
    if [user.first_name, user.last_name, user.email, user.date_of_birth, \
        user.shell_username].all? && EmailValidator.valid?(user.email.downcase) \
    && !User.find_by(shell_username: user.shell_username) \
    && !User.find_by(email: user.email.downcase)
      user.permission_level = 99
      user.activation_token = SecureRandom.uuid
      user.api_key = SecureRandom.uuid
      user.activated = false
      user.active = false
      user.shell_active = false
      user.protected = false
      user.user_global_id = SecureRandom.uuid
      user.save
      render json: { user_created: true, status: :ok }
    else
      render json: { user_created: false, status: :bad_request }
    end
  end

  def update
    if bearer_token
      user = User.find_by_email_and_api_key(params[:id], bearer_token)
      render json: { user_updated: true, status: :ok } if user.update(update_params)
    else
      render json: { user_updated: false, status: :bad_request }
    end
  end

  def destroy
    if bearer_token
      user = User.find_by_email_and_api_key(params[:id], bearer_token)
      if !user.protected
        render json: { user_destroyed: true, status: :gone } if user.destroy
      end
      render json: { user_destroyed: false, status: :not_modified }
    else
      render json: { user_destroyed: false, status: :bad_request }
    end
  end

  private

  def create_params
    params.require(:user)
          .permit(:first_name, :last_name, :email, \
                  :password, :date_of_birth, :shell_username)
    end

  def update_params
    params.require(:user)
          .permit(:email, :password)
  end
end
