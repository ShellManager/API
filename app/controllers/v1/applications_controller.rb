class V1::ApplicationsController < V1::VersionController
  def show
    application = Application.find_by(application_id: params[:id])
    if application
      render json: {html: "#{application.name} would like to use your account details.<br>Would you like to <a href='javascript:void(0)' id='allowSSO'><span style='color: green;text-decoration: none;border-bottom: 1px dotted green;'>allow</span></a> or <a href='javascript:void(0)' id='denySSO'><span style='color: red;text-decoration: none;border-bottom: 1px dotted red;'>deny</span></a> this?", redirect_uri: application.redirect_uri}
    else
      render json: {html: "<span style='color: yellow'>WARNING: No application found for client_id #{params[:id]}</span>", redirect_uri: nil}
    end
  end
end
