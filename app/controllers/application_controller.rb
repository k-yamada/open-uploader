class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  config.mongo_hosts  = "localhost:27017"
  config.mongo_dbname = "open-uploader"

end
