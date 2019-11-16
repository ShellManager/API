class V1::SessionsController < ApplicationController
  def create
    # The key bearer is in the format email:password, for example:
    # ZXhhbXBsZUBleGFtcGxlLmNvbTpQZXJmM2N0RXg0bXBsZVA6YXNzdzByZCE=
    # example@example.com:Perf3ctEx4mpleP:assw0rd!
    # This will only split on the first occurrence of `:`
    bearer = Base64.decode64(bearer_token).split(':', 2)
    email = bearer[0]
    password = bearer[1]
    user = User.find_by_email(email)
    if user && user.authenticate(password) && user.activated && user.active
      if user.tfa_enabled
        render json: { :api_key => nil, :status => :unauthorized }
      else
        Log.create!(user: user.user_global_id, administrative: false, action: "User Login from #{request.remote_ip}")
        render json: { :api_key => user.api_key, :status => :ok }
      end
    else
      render json: { :api_key => nil, :status => :unauthorized }
    end
  end
end
