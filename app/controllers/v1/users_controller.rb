# frozen_string_literal: true

class V1::UsersController < V1::VersionController
  def index
    super
  end
  
  def show
    user = User.find_by("email = ?", params[:id])
    render json: { user_exists: true, status: :ok } unless user.blank?
    render json: { user_exists: false, status: :ok } if user.blank?
  end

  def create
    user = User.new(create_params)
    if EmailValidator.valid?(user.email.downcase) \
    && !User.find_by(email: user.email.downcase)
      user.permission_level = 99
      user.activation_token = SecureRandom.uuid
      user.api_key = SecureRandom.uuid
      user.activated = false
      user.active = false
      user.protected = false
      user.user_global_id = SecureRandom.uuid
      user.tfa_enabled = false
      user.tfa_key = ROTP::Base32.random
      user.save
      @user = user
      PostmarkMailer.verify(@user).deliver_now
      Log.create!(user: user.user_global_id, administrative: false, action: "New Account Created")
      render json: { user_created: true, status: :ok }
    else
      render json: { user_created: false, status: :bad_request }
    end
  end

  def update
    if bearer_token
      user = User.find_by_email_and_api_key(params[:id], bearer_token)
      user.api_key = SecureRandom.uuid unless params[:user][:password].nil?
      user.protected ? user.update(protected_update) : user.update(update_params)
      Log.create!(user: user.user_global_id, administrative: false, action: "Account Updated")
      render json: { user_updated: true, status: :ok }
    else
      render json: { user_updated: false, status: :bad_request }
    end
  end

  def destroy
    if bearer_token
      user = User.find_by_email_and_api_key(params[:id], bearer_token)
      Log.destroy_all("user = #{user.user_global_id}")
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
          .permit(:email, :password)
    end

  def update_params
    params.require(:user)
          .permit(:password, :first_name, :last_name, \
                  :date_of_birth)
  end

  def protected_update
    params.require(:user)
          .permit(:password)
  end
end
