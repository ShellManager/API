class V1::SamlController < V1::VersionController

  @saml_config = YAML.load_file(File.join(Rails.root, 'config', 'saml.yml'))

  def index
    xml_uuid = SecureRandom.uuid
    SamlToken.create!(uuid: xml_uuid, xml: request.original_fullpath)
    redirect_to "http://localhost:3001/federation/saml?caller=#{xml_uuid}"
  end

  def show
    xml = SamlToken.find_by(uuid: params[:id])
    @user = User.find_by(user_global_id: params[:gid])

    if @user && xml && @user.saml_enabled
      authn_request, @relay_state = SAML2::Bindings::HTTPRedirect.decode(xml.xml)
      authn_request.resolve(self.class.service_provider)
      response = SAML2::Response.respond_to(authn_request,
                                            SAML2::NameID.new(self.class.entity_id),
                                            self.class.idp_name_email(@user))
      response.sign(self.class.x509_certificate, self.class.private_key)
      @saml_response = Base64.encode64(response.to_s)
      @saml_acs_url = authn_request.assertion_consumer_service.location
      SamlToken.delete(xml.id)
      render template: "saml2/http_post.html", layout: false
    else
      redirect_to "http://localhost:3001/500"
    end
  end

  protected

  def self.idp_name_email(user)
    SAML2::NameID.new(user.email, SAML2::NameID::Format::UNSPECIFIED)
  end

  def self.service_provider
    SAML2::Entity.parse(File.read(File.join(Rails.root, 'config', @saml_config['service_provider']))).service_providers.first
  end

  def self.entity_id
    @saml_config['entity_id']
  end

  def self.x509_certificate
    File.read(File.join(Rails.root, 'config', 'keys', @saml_config['encryption']['certificate']))
  end

  def self.private_key
    File.read(File.join(Rails.root, 'config', 'keys', @saml_config['encryption']['private_key']))
  end

  def self.signature_algorithm
    @saml_config['encryption']['algorithm']
  end


end
