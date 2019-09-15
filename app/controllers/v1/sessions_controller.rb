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
      render json: { :api_key => user.api_key, :status => :ok }
    else
      render json: { :api_key => nil, :status => :unauthorized }
    end
  end

  def destroy
    bearer = Base64.decode64(bearer_token).split(':', 2)
    email = bearer[0]
    password = bearer[1]
    user = User.find_by_email(email)
    if user && user.authenticate(password) && user.activated && user.active
      user.api_key = SecureRandom.uuid
      render json: { :status => :ok } if user.save
    else
      render json: { :status => :unauthorized }
    end
  end
end
