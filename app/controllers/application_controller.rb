class ApplicationController < ActionController::API
  def bearer_token
    pattern = /^Bearer /
    header  = request.headers["Authorization"]
    header.gsub(pattern, '') if header&.match(pattern)
  end

end
