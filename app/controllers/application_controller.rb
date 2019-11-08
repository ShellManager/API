class ApplicationController < ActionController::API
  before_action :set_cache_headers
  def bearer_token
    pattern = /^Bearer /
    header  = request.headers["Authorization"]
    header.gsub(pattern, '') if header&.match(pattern)
  end


  private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    response.headers['Last-Modified'] = Time.now.httpdate
  end
end
