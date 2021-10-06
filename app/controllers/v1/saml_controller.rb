class V1::SamlController < V1::VersionController

  def index
    xml_uuid = SecureRandom.uuid
    SamlToken.create!(uuid: xml_uuid, xml: request.original_fullpath)
    redirect_to "#{ENV['IDENTITY_UI_PROTOCOL']}://#{ENV['IDENTITY_UI_URL']}/federation/authorize?caller=#{xml_uuid}&client_id=#{params[:client_id]}"
  end

  def show
    xml = SamlToken.find_by(uuid: params[:id])
    @user = User.find_by(user_global_id: params[:gid])
    @sp = Application.find_by(application_id: params[:client_id])

    if @user && xml && @sp && @user.api_key == params[:api_key]
      authn_request, @relay_state = SAML2::Bindings::HTTPRedirect.decode(xml.xml)
      authn_request.resolve(self.class.service_provider(@sp))
      response = SAML2::Response.respond_to(authn_request,
                                            SAML2::NameID.new(self.class.entity_id(@sp)),
                                            self.class.idp_name_email(@user))
      response.sign(self.class.x509_certificate(@sp), self.class.private_key(@sp))
      @saml_response = Base64.encode64(response.to_s)
      @saml_acs_url = authn_request.assertion_consumer_service.location
      SamlToken.delete(xml.id)
      render template: "saml2/http_post.html", layout: false
    else
      redirect_to "#{ENV['IDENTITY_UI_PROTOCOL']}://#{ENV['IDENTITY_UI_URL']}/500"
    end
  end

  protected

  def self.idp_name_email(user)
    SAML2::NameID.new(user.email, SAML2::NameID::Format::UNSPECIFIED)
  end

  def self.service_provider(sp)
    SAML2::Entity.parse(sp.saml_service_provider).service_providers.first
  end

  def self.entity_id(sp)
    sp.saml_entity_id
  end

  def self.x509_certificate(sp)
    sp.saml_certificate
  end

  def self.private_key(sp)
    sp.saml_private_key
  end

  def self.signature_algorithm(sp)
    sp.saml_algorithm
  end


end
