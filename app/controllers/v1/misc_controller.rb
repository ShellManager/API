class V1::MiscController < V1::VersionController
    def verify_email
        user = User.find_by(email: params[:email])
        if user && user.activation_token == params[:code]
            user.activation_token = nil
            user.active = true
            user.activated = true
            user.save
            Log.create!(user: user.user_global_id, administrative: false, action: "Email Verified")
            render json: { status: :ok }
        else
            render json: { status: :bad_request }
        end
    end

    def reset
        user = User.find_by(email: params[:email])
        user.reset_code = SecureRandom.hex(8)
        user.save
        @user = user
        PostmarkMailer.reset(@user).deliver_now
    end

    def password
        json = JSON.parse request.raw_post
        user = User.find_by(reset_code: json["code"])
        if json["code"].present? && user
            user.password = json["password"]
            user.reset_code = nil
            user.save
            Log.create!(user: user.user_global_id, administrative: false, action: "Password Reset")
            render json: { status: :ok }
        else
            render json: { status: :bad_request }
        end
    end

    def multifactor
        json = JSON.parse request.raw_post
        user = params[:validate].present? ? User.find_by(email: json["email"]) : User.find_by(api_key: bearer_token)
        totp = ROTP::TOTP.new(user.tfa_key)
        if params[:validate].present? && json["code"]
            if totp.verify(json["code"])
                Log.create!(user: user.user_global_id, administrative: false, action: "User Login from #{request.remote_ip}")
                render json: { api_key: user.api_key, status: :ok }
            else
                render json: { api_key: nil, status: :bad_request }
            end
        elsif json["code"]
            if totp.verify(json["code"])
                user.tfa_enabled = !user.tfa_enabled
                user.tfa_key = ROTP::Base32.random if !user.tfa_enabled
                user.save
                render json: { user_updated: true, status: :ok }
            else
                render json: { user_updated: false, status: :bad_request }
            end
        end
    end
end
