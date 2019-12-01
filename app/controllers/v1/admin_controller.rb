# frozen_string_literal: true

class V1::AdminController < V1::VersionController
    def index
        user = User.find_by(api_key: bearer_token)
        if user && user.permission_level == 0
            render json: { users: User.all.order(id: :asc) }
        else
            render json: { users: nil, status: :bad_request }
        end
    end

    def show
        user = User.find_by(api_key: bearer_token)
        operable_user = User.find_by(email: params[:id])
        if user && user.permission_level = 0 && operable_user.protected == false
            operable_user.active = false if params[:operation] == "enable"
            operable_user.active = true if params[:operation] == "disable"
            operable_user.permission_level = 0 if params[:operation] == "admin"
            operable_user.permission_level = 99 if params[:operation] == "user"
            User.delete(operable_user.id) if params[:operation] == "delete"

            operable_user.tfa_enabled = false if params[:operation] == "2fa"
            operable_user.tfa_key = ROTP::Base32.random if params[:operation] == "2fa"

            operable_user.save
            render json: { user_updated: true, status: :ok }
        else
            render json: { user_updated: false, status: :bad_request }
        end
    end

end
