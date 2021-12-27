class V1::OauthController < V1::VersionController
  def authorize
    caller = SecureRandom.uuid
    OauthRequest.create!(client_id: params[:client_id], redirect_uri: params[:redirect_uri], scope: params[:scope],
                         response_mode: params[:response_mode], state: params[:state], nonce: params[:nonce],
                         caller_id: caller)
    redirect_to "#{ENV['IDENTITY_UI_PROTOCOL']}://#{ENV['IDENTITY_UI_URL']}/federation/authorize?caller=#{caller}&client_id=#{params[:client_id]}&authtype=oauth2"
  end
end
