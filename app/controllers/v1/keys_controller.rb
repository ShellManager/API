class V1::KeysController < V1::VersionController
  def index
    user = User.find_by(api_key: bearer_token)
    if user
      qr = RQRCode::QRCode.new("otpauth://totp/ShellManager:#{user.email}?secret=#{user.tfa_key}&digits=6&period=30", size: 5)

      png = qr.as_png(
            resize_gte_to: false,
            resize_exactly_to: false,
            fill: 'white',
            color: 'black',
            size: 250,
            border_modules: 1,
            module_px_size: 1,
            file: nil
      )

      render json: { tfa_enabled: user.tfa_enabled, tfa_key: user.tfa_key, image: Base64.encode64(png.to_s), status: :ok }
    else
      render json: { tfa_enabled: nil, tfa_key: nil, image: nil, status: :unauthorized }
    end
  end

  def destroy
    user = User.find_by(api_key: bearer_token)
    if user
      user.api_key = SecureRandom.uuid
      Log.create!(user: user.user_global_id, administrative: false, action: "API Key Reset")
      render json: { key_destroyed: true, status: :ok } if user.save
    else
      render json: { key_destroyed: false, status: :unauthorized }
    end
  end
end
